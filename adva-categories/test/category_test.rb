require File.expand_path('../test_helper', __FILE__)

require Adva::Categories.root.join('app/models/content_slice')

module AdvaCategoryTests
  class CategoryTest < Test::Unit::TestCase
    attr_reader :site, :section

    def setup
      @site = Site.first || Factory(:site)
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

    test 'content categorization' do
      foo = Factory(:content, :title => 'foo')
      bar = Factory(:content, :title => 'bar')

      category = Factory(:category)
      category.categorizables << foo << bar

      assert_equal [foo, bar], category.reload.categorizables
      assert_equal [category], foo.categories
      assert_equal [category], bar.categories
    end

    test 'categorized content scope' do
      foo = Factory(:content, :title => 'foo')
      bar = Factory(:content, :title => 'bar')
      baz = Factory(:content, :title => 'baz')

      category = Factory(:category)
      category.categorizables << foo << bar

       assert_equal [foo, bar], Content.categorized(category.id)
    end
  end
end

