require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportSourcePathTest < Test::Unit::TestCase
    include Adva::Static::Import::Source, TestHelper::Static

    test 'self_and_parents w/ a non-nested path' do
      assert_equal ['page.html'], Path.new('page.html').self_and_parents.map(&:local).map(&:to_s)
    end

    test 'self_and_parents w/ a nested path' do
      assert_equal ['foo', 'foo/bar', 'foo/bar/page.html'], Path.new('foo/bar/page.html').self_and_parents.map(&:local).map(&:to_s)
    end
  end
end

