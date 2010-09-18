# require File.expand_path('../../test_helper', __FILE__)
# 
# require 'rack'
# require 'adva/routing_filters/section_root'
# require 'adva/routing_filters/section_path'
# 
# module AdvaStatic
#   class RackWatchTest < Test::Unit::TestCase
#     include TestHelper::Application, Adva::Static::Rack
# 
#     attr_reader :app, :export_dir, :import_dir
# 
#     def setup
#       # Adva.out = $stdout
#       setup_application do
#         match 'admin/sites/:site_id/pages', :to => 'admin/pages#index', :as => 'admin_site_pages'
#         match 'admin/sites/:site_id/pages/:id', :to => 'admin/pages#show', :as => 'admin_site_page'
#       end
# 
#       @import_dir = dir('/tmp/adva-static-test/import')
#       @export_dir = dir('/tmp/adva-static-test/export')
#       File.open(import_dir.join('site.yml'), 'w') do |f|
#         f.write(YAML.dump(:host => 'ruby-i18n.org', :name => 'name', :title => 'title'))
#       end
# 
#       Site.create!(:host => 'ruby-i18n.org', :name => 'name', :title => 'title', :sections_attributes => [{ :type => 'Page', :name => 'Home' }])
#       super
#     end
# 
#     def teardown
#       watch.send(:kill_watch)
#       FileUtils.rm_r(import_dir)
#       FileUtils.rm_r(export_dir)
#       @watch = nil
#       super
#     end
# 
#     test "requests files referenced by a given rack-cache.purge header" do
#       @app = lambda do |env|
#         case env['PATH_INFO']
#         when '/'
#           [200, { PURGE_HEADER => ['/bar', '/baz'] }, '200 ok']
#         else
#           [200, {}, env['PATH_INFO']]
#         end
#       end
# 
#       watch.call(env_for('/').merge(STORE_HEADER => true))
# 
#       assert export_dir.join('index.html').file?
#       assert export_dir.join('bar.html').file?
#       assert export_dir.join('baz.html').file?
#     end
# 
#     test "imports and re-requests a modified file" do
#       @app = lambda do |env|
#         page = Page.first
#         request = ActionDispatch::TestRequest.new(env)
#         if request.method == 'POST'
#           page.update_attributes!(request.params[:page])
#           [302, { 'Location' => 'path/to/edit', PURGE_HEADER => '/' }, 'ok']
#         else
#           [200, {}, page.name]
#         end
#       end
# 
#       index = import_dir.join('index.yml')
#       FileUtils.touch(index)
#       assert !export_dir.join('index.html').file?
# 
#       watch
#       index.open('w') { |f| f.write('name: modified name') }
#       File.utime(index.mtime, future, index)
#       # sleep(2)
#       sleep(0.1) until export_dir.join('index.html').file?
# 
#       assert_equal 'modified name', export_dir.join('index.html').open { |f| f.read }
#     end
# 
#     protected
# 
#       def routes
#         @routes ||= ActionDispatch::Routing::RouteSet.new.tap do |routes|
#           routes.draw do
#             filter :section_root, :section_path
#             match 'pages/:id', :to => 'pages#show'
#             match 'admin/sites/:site_id/pages/:id', :to => 'admin/pages#update', :as => 'admin_site_page'
#           end
#           Admin::BaseController.send(:include, routes.url_helpers)
#         end
#       end
# 
#       def watch
#         @watch ||= Watch.new(Export.new(@app, :target => export_dir), :dir => import_dir, :routes => routes)
#       end
# 
#       def dir(path)
#         Pathname.new(path).tap { |path| FileUtils.mkdir_p(path) }
#       end
# 
#       def future
#         Time.local(Time.now.year + 1, Time.now.month, Time.now.day)
#       end
# 
#       def env_for(uri, options = nil)
#         Rack::MockRequest.env_for(uri, options || {})
#       end
#   end
# end