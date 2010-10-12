require File.expand_path('../test_helper', __FILE__)

module AdvaCategoryTests
  class CategoryTest < Test::Unit::TestCase
    attr_reader :site, :section

    def setup
      @site = Factory(:site)
      @section = site.sections.create(:name => 'Section')
    end

    test "category creation" do
      foo = section.categories.create!(:name => 'foo').reload
      bar = section.categories.create!(:name => 'bar', :parent_id => foo.id).reload

      assert_equal 'foo', foo.slug
      assert_equal 'bar', bar.slug

      assert_equal 'foo', foo.path
      assert_equal 'foo/bar', bar.path
    end
  end
end

