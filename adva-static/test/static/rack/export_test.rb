require File.expand_path('../../../test_helper', __FILE__)

require 'rack'

module AdvaStatic
  class RackExportTest < Test::Unit::TestCase
    include Adva::Static::Rack
    
    attr_reader :app
    
    def teardown
      FileUtils.rm_r(export.target)
      @export = nil
    end

    def export
      @export ||= Export.new(app, :target => '/tmp/adva-static-test/export')
    end
    
    test "exports a page /foo.html if response is 200" do
      @app = lambda { |env| [200, {}, '200 ok'] }
      
      export.call(env_for('/foo'))
      assert export.target.join('foo.html').file?
    end
    
    test "exports a page /index.html if response is 200" do
      @app = lambda { |env| [200, {}, '200 ok'] }
      
      export.call(env_for('/'))
      assert export.target.join('index.html').file?
    end

    test "does not export a page if response is not 200" do
      @app = lambda { |env| [404, {}, '404 not found'] }
      export.call(env_for('/foo'))
      assert !export.target.join('foo').file?
    end

    test "purges files referenced by a given rack-cache.purge header" do
      @app = lambda { |env| [200, { PURGE_HEADER => ['/bar', '/baz'] }, '200 ok'] }
      %w(bar.html baz.html).each { |path| FileUtils.touch(export.target.join(path)) }
      
      export.call(env_for('/'))
      assert export.target.join('index.html').file?
      assert !export.target.join('bar.html').file?
      assert !export.target.join('baz.html').file?
    end
    
    protected

      def env_for(uri, options = nil)
        Rack::MockRequest.env_for(uri, options || {})
      end
  end
end