require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class PathTest < Test::Unit::TestCase
    def path(path)
      Adva::Static::Export::Path.new(path)
    end

    test "path strips protocol and domain" do
      assert_equal '/foo/bar', path('http://example.org/foo/bar')
    end

    test "path strips query params" do
      assert_equal '/foo/bar', path('/foo/bar?baz=buz')
    end

    test "path adds a missing leading slash" do
      assert_equal '/foo/bar', path('foo/bar')
    end

    test "path strips a trailing slash" do
      assert_equal '/foo/bar', path('/foo/bar/')
    end

    test "extname returns the extension" do
      assert_equal '.html', path('foo/bar.html').extname
    end

    test "extname returns an empty string for a path that does not have an extension" do
      assert_equal '', path('foo/bar').extname
    end

    test "html? is true if the extname equals .html" do
      assert path('foo/bar.html').html?
    end

    test "html? is true if the extname is blank" do
      assert path('foo/bar').html?
    end

    test "html? is false if the extname does not equal .html" do
      assert !path('foo/bar.js').html?
    end

    test "filename returns the path with .html appended if the path is .html? (1)" do
      assert_equal 'foo/bar.html', path('foo/bar').filename
    end

    test "filename returns the path with .html appended if the path is .html? (2)" do
      assert_equal 'foo/bar.html', path('foo/bar.html').filename
    end

    test "filename uses index.html for a single slash" do
      assert_equal 'index.html', path('/').filename
    end
    
    test "can cope with broken remote urls" do
      assert path('http://localhost:3xxx').remote?
    end
  end
end