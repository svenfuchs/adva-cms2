require File.expand_path('../../test_helper', __FILE__)

require 'adva/routing_filters/categories'
require 'page'

module AdvaCategoriesTests
  class RoutingFilterCategoriesTest < Test::Unit::TestCase
    attr_reader :filter, :site, :home, :foo, :foo_bar, :bar

    def setup
      @site    = Factory(:site)
      @home    = site.sections.first.reload

      @foo     = home.categories.create!(:name => 'foo').reload
      @foo_bar = home.categories.create!(:name => 'bar', :parent => foo).reload
      @bar     = home.categories.create!(:name => 'bar').reload

      @filter = RoutingFilter::Categories.new
      site.sections.reset
    end

    test "recognizes /sections/1/categories/foo" do
      assert_equal "/sections/#{home.id}/categories/#{foo.id}", recognize("/sections/#{home.id}/categories/foo")
    end

    test "recognizes /sections/1/categories/foo/bar" do
      assert_equal "/sections/#{home.id}/categories/#{foo_bar.id}", recognize("/sections/#{home.id}/categories/foo/bar")
    end

    test "recognizes /sections/1/categories/foo.rss" do
      assert_equal "/sections/#{home.id}/categories/#{foo.id}.rss", recognize("/sections/#{home.id}/categories/foo.rss")
    end

    test "recognizes /sections/1/categories/foo?foo=bar" do
      assert_equal "/sections/#{home.id}/categories/#{foo.id}?foo=bar", recognize("/sections/#{home.id}/categories/foo?foo=bar")
    end

    test "generates from /sections/1/categories/1" do
      assert_equal "/sections/#{home.id}/categories/foo/bar", generate("/sections/#{home.id}/categories/#{foo_bar.id}")
    end

    test "generates from /sections/1/categories/1.rss" do
      assert_equal "/sections/#{home.id}/categories/foo/bar.rss", generate("/sections/#{home.id}/categories/#{foo_bar.id}.rss")
    end

    test "generates from /sections/1/categories/1?foo=bar" do
      assert_equal "/sections/#{home.id}/categories/foo/bar?foo=bar", generate("/sections/#{home.id}/categories/#{foo_bar.id}?foo=bar")
    end

    protected

      def recognize(path)
        filter.around_recognize(path, 'SERVER_NAME' => 'www.example.com') { }
        path
      end

      def generate(path)
        filter.around_generate({}) { path }
        path
      end
  end
end

