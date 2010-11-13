require File.expand_path('../../test_helper', __FILE__)

class Comment < ActiveRecord::Base
end

module AdvaCoreTests
  class PolymorphicUrlForTest < Test::Unit::TestCase
    include ActionDispatch::Routing::PolymorphicRoutes

    ActionDispatch::Routing::PolymorphicRoutes.send(:public, :build_named_route_call)

    attr_reader :objects, :view

    def setup
      @view = ActionView::Base.new('')
    end

    def teardown
      NamedRouteCall.cache.clear
      super
    end

    test 'returns the default method name if no other combination applies' do
      objects = [:admin, Factory(:site), Factory(:blog), Factory(:post), Comment]
      assert_equal 'admin_site_blog_post_comment_url', view.build_named_route_call(objects, :singular)
    end

    test 'returns admin_site_blog_post_comment_url if the view responds to this method' do
      objects = [:admin, Factory(:site), Factory(:blog), Factory(:post), Comment]
      stub_url_helpers('admin_site_blog_post_comment_url', 'admin_site_blog_content_comment_url',
        'admin_site_section_post_comment_url', 'admin_site_section_content_comment_url')
      assert_equal 'admin_site_blog_post_comment_url', view.build_named_route_call(objects, :singular)
    end

    test 'returns admin_site_blog_content_comment_url if the view responds to this method' do
      objects = [:admin, Factory(:site), Factory(:blog), Factory(:post), Comment]
      stub_url_helpers('admin_site_blog_content_comment_url', 'admin_site_section_post_comment_url',
        'admin_site_section_content_comment_url')
      assert_equal 'admin_site_blog_content_comment_url', view.build_named_route_call(objects, :singular)
    end

    test 'returns admin_site_section_post_comment_url if the view responds to this method' do
      objects = [:admin, Factory(:site), Factory(:blog), Factory(:post), Comment]
      stub_url_helpers('admin_site_section_post_comment_url', 'admin_site_section_content_comment_url')
      assert_equal 'admin_site_section_post_comment_url', view.build_named_route_call(objects, :singular)
    end

    test 'returns admin_site_section_content_comment_url if the view responds to this method' do
      objects = [:admin, Factory(:site), Factory(:blog), Factory(:post), Comment]
      stub_url_helpers('admin_site_section_content_comment_url')
      assert_equal 'admin_site_section_content_comment_url', view.build_named_route_call(objects, :singular)
    end

    test 'given [blog] it returns blog_url' do
      objects = [Factory(:blog)]
      stub_url_helpers('blog_url')
      assert_equal 'blog_url', view.build_named_route_call(objects, :singular)
    end

    test 'given [site, Section] w/ :new it returns new_site_section_url' do
      objects = [Factory(:site), Section]
      stub_url_helpers('site_sections_url')
      assert_equal 'new_site_section_url', view.build_named_route_call(objects, :singular, :action_prefix => 'new')
    end

    test 'given [site, :sections] it returns site_sections_url' do
      objects = [Factory(:site), :sections]
      stub_url_helpers('site_sections_url')
      assert_equal 'site_sections_url', view.build_named_route_call(objects, :singular)
    end

    test 'given [site, Section] it returns site_sections_url' do
      objects = [Factory(:site), Section]
      stub_url_helpers('site_sections_url')
      assert_equal 'site_sections_url', view.build_named_route_call(objects, :plural)
    end

    protected

      def stub_url_helpers(*methods)
        methods.each { |method| view.stubs(method) }
      end
  end
end

