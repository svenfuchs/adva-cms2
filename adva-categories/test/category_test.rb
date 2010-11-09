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

    test 'categorized content scope: includes contents categorized as the given category' do
      foo = Factory(:content, :title => 'foo')
      bar = Factory(:content, :title => 'bar')
      baz = Factory(:content, :title => 'baz')

      category = Factory(:category)
      category.categorizables << foo << bar

      assert_equal [foo, bar], Content.categorized(category.id)
    end

    test 'categorized content scope: includes contents categorized as children of the given category' do
      foo = Factory(:content, :title => 'foo')
      bar = Factory(:content, :title => 'bar')
      baz = Factory(:content, :title => 'baz')

      parent = Factory(:category)
      child  = Factory(:category)
      child.move_to_child_of(parent)
      child.categorizables << foo << bar

      assert_equal [foo, bar], Content.categorized(parent.id)
    end

    test 'adding a categorization through nested attributes' do
      foo     = Factory(:category, :name => 'foo')
      bar     = Factory(:category, :name => 'bar')
      content = Factory(:content, :title => 'content')

      content.update_attributes!(:categorizations_attributes => [{ :category_id => foo.id }, { :category_id => bar.id }])
      assert_equal [foo, bar], content.reload.categories
    end

    test 'removing a categorization through nested attributes' do
      foo     = Factory(:category)
      content = Factory(:content, :title => 'foo')
      content.categories << foo
      assert_equal [foo], content.reload.categories

      content.update_attributes!(:categorizations_attributes => [{ :id => content.categorizations.first.id, '_destroy' => '1' }])
      assert content.reload.categories.empty?
    end
  end
end

