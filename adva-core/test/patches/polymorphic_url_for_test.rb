require File.expand_path('../../test_helper', __FILE__)

class Comment < ActiveRecord::Base
end

module AdvaCoreTests
  class PolymorphicUrlForTest < Test::Unit::TestCase
    include ActionDispatch::Routing::PolymorphicRoutes

    ActionDispatch::Routing::PolymorphicRoutes.send(:public, :build_named_route_call)

    attr_reader :objects, :view

    def setup
      @objects = [:admin, Factory(:site), Factory(:blog), Factory(:post), Comment]
      @view = ActionView::Base.new('')
    end

    test 'classes_for_named_route_call' do
      expected = [[:admin], ['Site'], ['Blog', 'Section'], ['Post', 'Content'], ['Comment']]
      assert_equal expected, classes_for_named_route_call(objects)
    end

    test 'class_name_combinations_for_named_route_call' do
      expected = [
        [:admin, 'Site', 'Blog', 'Post', 'Comment'],
        [:admin, 'Site', 'Blog', 'Content', 'Comment'],
        [:admin, 'Site', 'Section', 'Post', 'Comment'],
        [:admin, 'Site', 'Section', 'Content', 'Comment']
      ]
      assert_equal expected, class_name_combinations_for_named_route_call(objects)
    end

    test 'build_named_route_call returns the default method name if no other combination applies' do
      assert_equal 'admin_site_blog_post_comment_url', view.build_named_route_call(objects, :singular)
    end

    test 'build_named_route_call returns admin_site_blog_post_comment_url if the view responds to this method' do
      stub_url_helpers('admin_site_blog_post_comment_url', 'admin_site_blog_content_comment_url',
        'admin_site_section_post_comment_url', 'admin_site_section_content_comment_url')
      assert_equal 'admin_site_blog_post_comment_url', view.build_named_route_call(objects, :singular)
    end

    test 'build_named_route_call returns admin_site_blog_content_comment_url if the view responds to this method' do
      stub_url_helpers('admin_site_blog_content_comment_url', 'admin_site_section_post_comment_url',
        'admin_site_section_content_comment_url')
      assert_equal 'admin_site_blog_content_comment_url', view.build_named_route_call(objects, :singular)
    end

    test 'build_named_route_call returns admin_site_section_post_comment_url if the view responds to this method' do
      stub_url_helpers('admin_site_section_post_comment_url', 'admin_site_section_content_comment_url')
      assert_equal 'admin_site_section_post_comment_url', view.build_named_route_call(objects, :singular)
    end

    test 'build_named_route_call returns admin_site_section_content_comment_url if the view responds to this method' do
      stub_url_helpers( 'admin_site_section_content_comment_url')
      assert_equal 'admin_site_section_content_comment_url', view.build_named_route_call(objects, :singular)
    end

    protected

      def stub_url_helpers(*methods)
        methods.each { |method| view.stubs(method) }
      end
  end
end

