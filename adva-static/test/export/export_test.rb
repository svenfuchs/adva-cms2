require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ExportTest < Test::Unit::TestCase
    class Application
      def call(env)
        case env['PATH_INFO']
        when '/foo'
          [200, {}, '<h1>Foo</h1><a href="/bar">bar</a>']
        when '/bar'
          [301, { 'Location' => '/bar/1' }, '']
        when '/bar/1'
          [200, {}, '<h1>Bar</h1><a href="/foo">foo</a>']
        end
      end
    end

    attr_reader :exporter

    def setup
      Site.create(
        :host => 'localhost:3000',
        :title => 'Site Title',
        :name => 'Site Name',
        :sections_attributes => [{ :name => 'Home' }]
      )
      @exporter = Adva::Static::Export.new(Application.new, :target => '/tmp/adva-static-test/export')
    end

    def path(path)
      Adva::Static::Export::Path.new(path)
    end

    test "get /foo" do
      assert_match /Foo/, exporter.send(:get, '/foo').body
    end

    test "get /bar redirects to /bar/1" do
      assert_match /Bar/, exporter.send(:get, '/bar').body
    end

    test "process" do
      exporter.store.expects(:write).with('/foo', '<h1>Foo</h1><a href="/bar">bar</a>')
      exporter.send(:process, path('/foo'))
      assert exporter.queue.include?('/bar')
    end
  end
end