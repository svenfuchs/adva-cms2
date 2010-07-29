require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class StoreTest < Test::Unit::TestCase
    attr_reader :store

    def setup
      FakeFS.activate!

      dir = Pathname.new('/tmp/adva-static-test/export')
      @store = Adva::Static::Store.new(dir)

      FileUtils.mkdir_p(dir)
      FileUtils.touch(dir.join('index.html'))
    end
    
    def teardown
      FakeFS.deactivate!
    end
    
    def path(path)
      Adva::Static::Path.new(path)
    end

    test "exists? finds an existing path" do
      assert store.exists?(path('/index.html'))
    end

    test "exists? finds an existing path w/o a leading slash" do
      assert store.exists?(path('index.html'))
    end

    test "exists? does not find a missing path" do
      assert !store.exists?(path('/missing.html'))
    end
    
    test "write" do
      store.write(path('/foo/bar'), 'foo and bar')
      assert_equal 'foo and bar', File.read(store.dir.join('foo/bar.html'))
    end
  end
end