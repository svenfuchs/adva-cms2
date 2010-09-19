require File.expand_path('../../test_helper', __FILE__)

require 'adva/routing_filters/section_path'
require 'page'

module AdvaCoreTests
  class SectionPathTest < Test::Unit::TestCase
    attr_reader :filter, :site, :home, :docs, :api, :pages

    def setup
      @site   = Factory(:site)
      @home   = site.sections.first
      @docs   = site.sections.create!(:name => 'docs') 
      @api    = site.sections.create!(:name => 'api', :parent => docs)
      @pages  = site.sections.create!(:name => 'pages')
      @filter = RoutingFilter::SectionPath.new

      [home, docs, api, pages].map(&:reload)
      site.sections.reset
    end

    test "recognizes /docs" do
      assert_equal "/sections/#{docs.id}", recognize('/docs')
    end 

    test "recognizes /docs/api" do
      assert_equal "/sections/#{api.id}", recognize('/docs/api')
    end

    test "recognizes /docs/articles/1" do
      assert_equal "/sections/#{docs.id}/articles/1", recognize('/docs/articles/1')
    end

    test "recognizes /docs.rss" do
      assert_equal "/sections/#{docs.id}.rss", recognize('/docs.rss')
    end

    test "recognizes /docs?foo=bar" do
      assert_equal "/sections/#{docs.id}?foo=bar", recognize('/docs?foo=bar')
    end

    test "generates from /sections/1" do
      assert_equal '/docs', generate("/sections/#{docs.id}")
    end

    test "generates from /sections/2" do
      assert_equal '/docs/api', generate("/sections/#{api.id}")
    end

    test "generates from /sections/1/foo" do
      assert_equal '/docs/foo', generate("/sections/#{docs.id}/foo")
    end

    test "generates from /sections/1.rss" do
      assert_equal '/docs.rss', generate("/sections/#{docs.id}.rss")
    end

    test "generates from /sections/1?foo=bar" do
      assert_equal '/docs?foo=bar', generate("/sections/#{docs.id}?foo=bar")
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