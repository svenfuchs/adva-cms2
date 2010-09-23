require File.expand_path('../test_helper', __FILE__)

require 'core_ext/ruby/file/basename_multiple_extensions'

module AdvaStatic
  class CoreExtTest < Test::Unit::TestCase
    attr_reader :exporter

    test "File.basename with multiple extensions" do
      assert_equal 'filename', File.basename('filename.foo', '.foo')
      assert_equal 'filename', File.basename('filename.foo', ['.foo', '.bar'])
    end
  end
end