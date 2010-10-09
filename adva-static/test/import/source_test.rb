require File.expand_path('../test_helper', __FILE__)

module AdvaStatic
  class ImportSourceTest < Test::Unit::TestCase
    include Adva::Static::Import::Model, TestHelper::Static

    test "given a relative path and a root" do
      source = source('foo/page.html')
      assert_equal 'foo/page.html', source.to_s
    end

    test "given a relative path w/ leading slash and a root" do
      source = source('/foo/page.html')
      assert_equal 'foo/page.html', source.to_s
    end

    test "given an absolute path and a root" do
      source = source("#{import_dir}/foo/page.html")
      assert_equal 'foo/page.html', source.to_s
    end

    test 'basename' do
      assert_equal 'page', source('foo/page.html').basename
    end

    test 'path' do
      assert_equal 'foo/page', source('foo/page.html').path
    end

    test 'full_path' do
      assert_equal "#{import_dir}/foo/page.html", source('foo/page.html').full_path.to_s
    end

    test 'self_and_parents w/ a non-nested path' do
      assert_equal ['page'], source('page.html').self_and_parents.map(&:path)
    end

    test 'self_and_parents w/ a nested path' do
      assert_equal ['foo', 'foo/bar', 'foo/bar/page'], source('foo/bar/page.html').self_and_parents.map(&:path)
    end

    test 'sorts index paths to the top, otherwise sorts by name' do
      sources = [source('foo.html'), source('index.html'), source('bar.html')].sort
      assert_equal ['index', 'bar', 'foo'], sources.map(&:path)
    end

    test 'root?' do
      assert source('index.yml').root?
      assert source('index.html').root?
      assert !source('foo.html').root?
    end
  end
end
