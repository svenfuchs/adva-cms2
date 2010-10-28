require File.expand_path('../../test_helper', __FILE__)

require 'adva/routing_filters/categories'
require 'page'

module AdvaCategoriesTests
  class RoutingFilterCategoriesTest < Test::Unit::TestCase
    attr_reader :filter, :site, :home, :foo, :bar, :params

    def setup
      @site = Factory(:site)
      @home = site.sections.first.reload

      @foo  = home.categories.create!(:name => 'foo').reload
      @bar  = home.categories.create!(:name => 'bar', :parent => foo).reload

      @filter = RoutingFilter::Categories.new
      site.sections.reset

      @params = {}
    end

    test "recognizes /sections/1/categories/foo and sets the category param" do
      assert_equal "/sections/#{home.id}", recognize("/sections/#{home.id}/categories/foo")
      assert_equal foo.id.to_s, params[:category_id]
    end

    test "recognizes /sections/1/categories/foo/bar and sets the category param" do
      assert_equal "/sections/#{home.id}", recognize("/sections/#{home.id}/categories/foo/bar")
      assert_equal bar.id.to_s, params[:category_id]
    end

    test "recognizes /sections/1/categories/foo.rss and sets the category param" do
      assert_equal "/sections/#{home.id}.rss", recognize("/sections/#{home.id}/categories/foo.rss")
      assert_equal foo.id.to_s, params[:category_id]
    end

    test "recognizes /sections/1/categories/foo?foo=bar and sets the category param" do
      assert_equal "/sections/#{home.id}?foo=bar", recognize("/sections/#{home.id}/categories/foo?foo=bar")
      assert_equal foo.id.to_s, params[:category_id]
    end

    test "recognizes /categories/foo and sets the category param" do
      assert_equal "/", recognize("/categories/foo")
      assert_equal foo.id.to_s, params[:category_id]
    end

    test "generates from /sections/1/categories/1 and a category param" do
      assert_equal "/sections/#{home.id}/categories/foo/bar", generate("/sections/#{home.id}", :category_id => bar.id)
    end

    test "generates from /sections/1/categories/1.rss and a category param" do
      assert_equal "/sections/#{home.id}/categories/foo/bar.rss", generate("/sections/#{home.id}.rss", :category_id => bar.id)
    end

    test "generates from /sections/1/categories/1?foo=bar and a category param " do
      assert_equal "/sections/#{home.id}/categories/foo/bar?foo=bar", generate("/sections/#{home.id}?foo=bar", :category_id => bar.id)
    end

    test "generates from /blogs/1/categories/1 and a category param " do
      assert_equal "/blogs/#{home.id}/categories/foo/bar", generate("/blogs/#{home.id}", :category_id => bar.id)
    end

    protected

      def recognize(path)
        filter.around_recognize(path, 'SERVER_NAME' => 'www.example.com') { params}
        path
      end

      def generate(path, params = {})
        filter.around_generate(params) { path }
        path
      end
  end
end

