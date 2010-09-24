require File.expand_path('../../test_helper', __FILE__)

require 'core_ext/ruby/file/basename_multiple_extensions'

module AdvaStatic
  class ImportSourceTest < Test::Unit::TestCase
    include Adva::Static::Import

    test "given a relative path and a root" do
      source = Source.new('foo/page.html', '/path/to/import')
      assert_equal 'foo/page.html', source.to_s
    end

    test "given a relative path w/ leading slash and a root" do
      source = Source.new('/foo/page.html', '/path/to/import')
      assert_equal 'foo/page.html', source.to_s
    end

    test "given an absolute path and a root" do
      source = Source.new('/path/to/import/foo/page.html', '/path/to/import')
      assert_equal 'foo/page.html', source.to_s
    end
    
    test 'basename' do
      assert_equal 'page', Source.new('foo/page.html', '/path/to/import').basename
    end
    
    test 'path' do
      assert_equal 'foo/page', Source.new('foo/page.html', '/path/to/import').path
    end
  end
end