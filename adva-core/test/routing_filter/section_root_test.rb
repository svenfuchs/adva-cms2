require File.expand_path('../../test_helper', __FILE__)

require 'adva/routing_filters/section_root'
require 'blog'
require 'catalog'
require 'page'

Site.has_many :blogs
Site.has_many :catalogs

module AdvaCoreTests
  class SectionRootTest < Test::Unit::TestCase
    attr_reader :filter, :site, :root, :page, :blog, :catalog

    def setup
      @site    = Site.create!(:name => 'site', :title => 'site', :host => 'www.example.com')
      @root    = site.pages.create!(:title => 'root')
      @page    = site.pages.create!(:title => 'page')
      @blog    = site.blogs.create!(:title => 'blog')
      @catalog = site.catalogs.create!(:title => 'products')
      @filter  = RoutingFilter::SectionRoot.new

      [root, page, blog, catalog].map(&:reload)
      site.sections.reset
    end

    test "prepend_root_section prepends to /" do
      assert_match %r(^/pages/\d+/$), prepend_root_section('/')
    end

    test "prepend_root_section prepends to /article" do
      assert_match %r(^/pages/\d+/article$), prepend_root_section('/article')
    end

    test "prepend_root_section prepends to /2009/01/01/foo-bar if root section is a blog" do
      blog.move_to_left_of(root)
      assert_match %r(^/blogs/\d+/2009/01/01/foo-bar$), prepend_root_section('/2009/01/01/foo-bar')
    end

    test "prepend_root_section does not prepends to /2009/01/01/foo-bar if root section is not a blog" do
      assert_match %r(^/2009/01/01/foo-bar$), prepend_root_section('/2009/01/01/foo-bar')
    end

    test "prepend_root_section prepends to /products/foo-bar if root section is a catalog" do
      catalog.move_to_left_of(root)
      assert_match %r(^/catalogs/\d+/products/foo-bar$), prepend_root_section('/products/foo-bar')
    end

    test "prepend_root_section does not prepend to /products/foo-bar if root section is not a catalog" do
      assert_match %r(^/products/foo-bar$), prepend_root_section('/products/foo-bar')
    end

    test "prepend_root_section does not prepend to /installations/new" do
      assert_equal '/installations/new', prepend_root_section('/installations/new')
    end

    test "/admin/sites is excluded" do
      assert filter.send(:excluded?, '/admin/sites')
    end
  
    test "remove_root_section removes /pages/:id for the root section" do
      assert_equal '/', remove_root_section("/pages/#{root.id}")
    end
  
    test "remove_root_section does not remove /pages/:id for non-root sections" do
      assert_match %r(^/pages/\d+$), remove_root_section("/pages/#{page.id}")
    end
  
    test "remove_trailing_slash removes a trailing slash from an otherwise non-empty path" do
      assert_equal '/foo', remove_trailing_slash('/foo/')
    end
  
    test "remove_trailing_slash does not remove a trailing slash from an otherwise empty path" do
      assert_equal '/', remove_trailing_slash('/')
    end
  
    def prepend_root_section(path)
      filter.send(:prepend_root_section!, path, site.sections.root)
      path
    end
  
    def remove_root_section(path)
      filter.send(:remove_root_section!, path)
      path
    end
  
    def remove_trailing_slash(path)
      filter.send(:remove_trailing_slash!, path)
      path
    end
  end
end