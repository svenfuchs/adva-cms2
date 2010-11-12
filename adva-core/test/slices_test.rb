require File.expand_path('../test_helper', __FILE__)

module AdvaCoreTests
  class SlicesTest < Test::Unit::TestCase
    test "slice_paths" do
      assert Adva::Blog.slice_paths.any? { |path| File.basename(path) == 'models' }
    end

    # test "slice_path: given path/to/foo.rb it returns nil" do
    #   filename = ActiveSupport::Dependencies.slice_path('path/to/foo.rb')
    #   assert_nil filename
    # end

    test "slice_path: given a path in a slice dir it returns the slice filename" do
      filename = ActiveSupport::Dependencies.slice_path('path/to/models/foo.rb')
      assert_equal 'foo_slice.rb', filename
    end

    test "slice_path: given a path in a subdir of a slice dir it returns the relative path the slice file" do
      filename = ActiveSupport::Dependencies.slice_path('path/to/models/subdir/foo.rb')
      assert_equal 'subdir/foo_slice.rb', filename
    end

    test "slice_path: given a path that includes more than one extension it still returns the slice filename" do
      filename = ActiveSupport::Dependencies.slice_path('path/to/models/foo.html.rb')
      assert_equal 'foo_slice.html.rb', filename
    end
  end
end

