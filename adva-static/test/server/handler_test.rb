require File.expand_path('../../test_helper', __FILE__)

require 'rack'

module AdvaStatic
  class WatchHandlerTest < Test::Unit::TestCase
    include Adva::Static::Server
    Handler = Watch::Handler

    Handler.instance_methods.each { |method| Handler.send(:public, method) }

    class Watcher
      def update; end
    end

    attr_reader :root, :file, :handler

    def setup
      past = Time.parse('2010-01-01')
      Time.stubs(:now).returns(Time.parse('2010-01-02'))

      @root = Pathname.new('/tmp/adva-static-test')
      @file = root.join('foo.html')

      root.mkpath
      FileUtils.touch(file.to_s)
      root.join('foo.html').utime(past, past)

      @handler = Handler.new(Watcher.new, root.join('**/*').to_s)
    end

    def teardown
      root.rmtree
    end

    def update(file)
      file.utime(now, now)
    end

    def create(filename)
      root.join(filename).tap do |file|
        FileUtils.touch(file.to_s)
        file.utime(now, now)
      end
    end

    def rename(file, target)
      FileUtils.mv(file.to_s, root.join(target).to_s)
    end

    def delete(file)
      file.unlink
    end

    def now
      @now ||= Time.parse('2010-01-03')
    end

    test "handler recognizes updated file mtimes" do
      update(file)
      assert_equal [[file.to_s, :modified]], handler.events
    end

    test "handler recognizes created files" do
      file = create('bar.html')
      assert_equal [[file.to_s, :created]], handler.events
    end

    test "handler recognizes deleted files" do
      delete(file)
      assert_equal [[file.to_s, :deleted]], handler.events
    end

    test "handler recognizes renamed files as :deleted and :created" do
      rename(file, 'bar.html')
      assert_equal [[file.to_s, :deleted], [root.join('bar.html').to_s, :created]], handler.events
    end

    test "handler recognizes events on subsequent changes" do
      # change a file
      @now = Time.parse('2010-01-03')
      update(file)
      assert_equal [[file.to_s, :modified]], handler.events

      # create a file
      @now = Time.parse('2010-01-04')
      file = create('bar.html')
      assert_equal [[file.to_s, :created]], handler.events

      # delete a file
      @now = Time.parse('2010-01-05')
      delete(file)
      assert_equal [[file.to_s, :deleted]], handler.events

      # create a file
      @now = Time.parse('2010-01-06')
      file = create('baz.html')
      assert_equal [[file.to_s, :created]], handler.events

      # change a file
      @now = Time.parse('2010-01-07')
      update(file)
      assert_equal [[file.to_s, :modified]], handler.events
    end
  end
end
