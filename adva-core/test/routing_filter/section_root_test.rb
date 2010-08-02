require File.expand_path('../../test_helper', __FILE__)

require 'routing_filter/section_root'
require 'page'

module AdvaCore
  class SectionRootTest < Test::Unit::TestCase
    attr_reader :filter, :root, :non_root

    def setup
      site      = Site.new(:name => 'site', :title => 'site', :host => 'www.example.com')
      @root     = Page.create!(:title => 'root', :site => site)
      @non_root = Page.create!(:title => 'non-root', :site => site)
      @filter   = RoutingFilter::SectionRoot.new
    end

    test "prepend_root_section prepends to /" do
      assert_match %r(^/pages/\d+/$), prepend_root_section('/')
    end

    test "prepend_root_section prepends to /article" do
      assert_match %r(^/pages/\d+/article$), prepend_root_section('/article')
    end

    test "prepend_root_section prepends to /2009/01/01/foo-bar" do
      assert_match %r(^/pages/\d+/2009/01/01/foo-bar$), prepend_root_section('/2009/01/01/foo-bar')
    end

    test "prepend_root_section prepends to /products/foo-bar" do
      assert_match %r(^/pages/\d+/products/foo-bar$), prepend_root_section('/products/foo-bar')
    end

    test "prepend_root_section does not prepend to /installations/new" do
      assert_equal '/installations/new', prepend_root_section('/installations/new')
    end

    test "prepend_root_section does not prepend to /admin/sites" do
      assert_equal '/admin/sites', prepend_root_section('/admin/sites')
    end
  
    test "remove_root_section removes /pages/:id for the root section" do
      assert_equal '/', remove_root_section("/pages/#{root.id}")
    end
  
    test "remove_root_section removes /pages/:id for non-root sections" do
      assert_match %r(^/pages/\d+$), remove_root_section("/pages/#{non_root.id}")
    end
  
    test "remove_trailing_slash removes a trailing slash from an otherwise non-empty path" do
      assert_equal '/foo', remove_trailing_slash('/foo/')
    end
  
    test "remove_trailing_slash does not remove a trailing slash from an otherwise empty path" do
      assert_equal '/', remove_trailing_slash('/')
    end
  
    def prepend_root_section(path)
      filter.send(:prepend_root_section!, path, root)
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