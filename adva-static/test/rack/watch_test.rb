require File.expand_path('../../test_helper', __FILE__)

require 'rack'
require 'adva/routing_filters/section_root'
require 'adva/routing_filters/section_path'

module AdvaStatic
  class RackWatchTest < Test::Unit::TestCase
    include TestHelper::Application, TestHelper::Static, Adva::Static::Rack

    attr_reader :app, :export_dir, :import_dir

    def setup
      Watch.any_instance.stubs(:run!)
      setup_application
      setup_directories
      Factory(:site, :host => 'ruby-i18n.org')
      super
    end

    def teardown
      teardown_directories
      @watch = nil
      super
    end

    test "requests files referenced by a given rack-cache.purge header" do
      @app = lambda do |env|
        case env['PATH_INFO']
        when '/'
          [200, { PURGE_HEADER => ['/bar', '/baz'] }, '200 ok']
        else
          [200, {}, env['PATH_INFO']]
        end
      end

      watch.call(env_for('/').merge(STORE_HEADER => true))

      assert export_dir.join('index.html').file?
      assert export_dir.join('bar.html').file?
      assert export_dir.join('baz.html').file?
    end

    test "imports and re-requests a modified file" do
      @app = lambda do |env|
        page = Page.first
        request = ActionDispatch::TestRequest.new(env)
        if request.method == 'POST'
          page.update_attributes!(request.params[:page])
          [302, { 'Location' => 'path/to/edit', PURGE_HEADER => '/' }, 'ok']
        else
          [200, {}, page.name]
        end
      end

      index = import_file('index.yml', :name => 'the page name')
      assert !export_dir.join('index.html').file?, 'index.html already exists'

      watch = self.watch
      index.utime(index.atime, future)
      watch.send(:handler).trigger

      assert export_dir.join('index.html').file?, 'cannot find exported index.html'
      assert_equal 'the page name', export_dir.join('index.html').open { |f| f.read }
    end

    # test "imports a created file" do
    #   @app = lambda do |env|
    #     page = Page.first
    #     request = ActionDispatch::TestRequest.new(env)
    #     if request.method == 'POST'
    #       page.update_attributes!(request.params[:page])
    #       [302, { 'Location' => 'path/to/edit', PURGE_HEADER => '/' }, 'ok']
    #     else
    #       [200, {}, page.name]
    #     end
    #   end

    #   watch = self.watch
    #   index = import_file('page.yml', :name => 'the page name')
    #   assert !export_dir.join('page.html').file?
    #   index.utime(index.atime, future)

    #   watch.send(:handler).trigger

    #   assert_equal 'the page name', export_dir.join('page.html').open { |f| f.read }
    # end

    protected

      def setup_application
        super do
          match 'admin/sites/:site_id/pages', :to => 'admin/pages#index', :as => 'admin_site_pages'
          match 'admin/sites/:site_id/pages/:id', :to => 'admin/pages#show', :as => 'admin_site_page'
        end
      end

      def setup_directories
        @import_dir = dir('/tmp/adva-static-test/import')
        @export_dir = dir('/tmp/adva-static-test/export')
        import_file('site.yml', :host => 'ruby-i18n.org', :name => 'name', :title => 'title')
      end

      def teardown_directories
        FileUtils.rm_r(import_dir)
        FileUtils.rm_r(export_dir)
      end

      def routes
        @routes ||= ActionDispatch::Routing::RouteSet.new.tap do |routes|
          routes.draw do
            filter :section_root, :section_path
            match 'pages/:id', :to => 'pages#show'
            match 'admin/sites/:site_id/pages/:id', :to => 'admin/pages#update', :as => 'admin_site_page'
          end
          Admin::BaseController.send(:include, routes.url_helpers)
        end
      end

      def watch
        @watch ||= Watch.new(Export.new(@app, :target => export_dir), :dir => import_dir, :routes => routes)
      end

      def dir(path)
        Pathname.new(path).tap { |path| FileUtils.mkdir_p(path) }
      end

      def import_file(filename, attributes)
        Pathname.new(import_dir.join(filename)).tap do |file|
          File.open(file, 'w') { |f| f.write(YAML.dump(attributes)) }
        end
      end

      def env_for(uri, options = nil)
        Rack::MockRequest.env_for(uri, options || {})
      end
  end
end
