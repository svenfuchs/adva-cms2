require File.expand_path('../../test_helper', __FILE__)

module AdvaCoreTests
  class RackStaticTest < Test::Unit::TestCase
    attr_reader :static, :root, :app

    def setup
      @app    = lambda { |env| [200, {}, ["app called: #{env['PATH_INFO']}"]] }
      @root   = Pathname.new('/tmp/adva-cms2-test/tmp/rack/directory')
      @static = Adva::Rack::Static.new(app)
      @static.stubs(:directories).returns([::Rack::File.new(root.to_s)])
      super
    end

    def teardown
      root.rmtree rescue nil
    end

    test 'responds with an existing file javascripts/application.js' do
      touch('javascripts/adva-core/foo.js')
      status, headers, response = static.call(env_for('/javascripts/adva-core/foo.js'))
      assert_equal 200, status
      assert_equal 'application/javascript', headers['Content-Type']
    end

    test 'responds with an existing file stylesheets/styles.css' do
      touch('stylesheets/adva-core/foo.css')
      status, headers, response = static.call(env_for('/stylesheets/adva-core/foo.css'))
      assert_equal 200, status
      assert_equal 'text/css', headers['Content-Type']
    end

    test 'responds with a 404 for a non-existing file stylesheets/styles.css' do
      status, headers, response = static.call(env_for('/stylesheets/adva-core/foo.css'))
      assert_equal 404, status
      assert_equal "File not found: /stylesheets/adva-core/foo.css\n", response.join
    end

    test 'passes requests to non-static, non-existing paths to the application' do
      status, headers, response = static.call(env_for('/non-static/index.html'))
      assert_equal 200, status
      assert_equal "app called: /non-static/index.html", response.join
    end

    test 'passes requests to non-static, existing paths to the application' do
      touch('/non-static/index.html')
      status, headers, response = static.call(env_for('/non-static/index.html'))
      assert_equal 200, status
      assert_equal "app called: /non-static/index.html", response.join
    end

    protected

      def touch(path)
        root.join(path).dirname.mkpath
        FileUtils.touch(root.join(path))
      end

      def env_for(*args)
        Rack::MockRequest.env_for(*args)
      end
  end
end



