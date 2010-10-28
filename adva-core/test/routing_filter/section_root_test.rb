require File.expand_path('../../test_helper', __FILE__)

require 'adva/routing_filters/section_root'
require 'blog'
require 'page'

Site.has_many :blogs

module AdvaCoreTests
  class SectionRootTest < Test::Unit::TestCase
    attr_reader :filter, :site, :root, :page, :blog

    def setup
      @site    = Site.create!(:name => 'site', :title => 'site', :host => 'www.example.com')
      @root    = site.pages.create!(:name => 'root')
      @page    = site.pages.create!(:name => 'page')
      @blog    = site.blogs.create!(:name => 'blog')
      @filter  = RoutingFilter::SectionRoot.new

      [root, page, blog].map(&:reload)
      site.sections.reset
    end

    test "recognizes /" do
      assert_equal "/pages/#{root.id}", recognize('/')
    end

    test "recognizes /.rss" do
      assert_equal "/pages/#{root.id}.rss", recognize('/.rss')
    end

    test "recognizes /article/1" do
      assert_equal "/pages/#{root.id}/article/1", recognize('/article/1')
    end

    test "recognizes /article/1.rss" do
      assert_equal "/pages/#{root.id}/article/1.rss", recognize('/article/1.rss')
    end

    test "recognition does not touch /docs" do
      assert_equal "/docs", recognize('/docs')
    end

    test "recognition does not touch /sections/2" do
      assert_equal "/sections/2", recognize('/sections/2')
    end

    test "generates from /pages/1" do
      assert_equal '/', generate("/pages/#{root.id}")
    end

    test "generates from /pages/1.rss" do
      assert_equal '/.rss', generate("/pages/#{root.id}.rss")
    end

    test "generates from /pages/1/article/1" do
      assert_equal '/article/1', generate("/pages/#{root.id}/article/1")
    end

    test "generates from /pages/1/article/1.rss" do
      assert_equal '/article/1.rss', generate("/pages/#{root.id}/article/1.rss")
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
