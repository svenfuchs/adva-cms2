require File.expand_path('../test_helper', __FILE__)

module AdvaBlogTests
  class ReferencesTest < Test::Unit::TestCase
    include TestHelper::Application

    attr_reader :site, :blog, :posts

    def setup
      setup_application do
        match 'blogs/:id(/:year(/:month(/:day)))',      :to => 'posts#index',    :as => :blog
        match 'blogs/:blog_id/:year/:month/:day/:slug', :to => 'posts#show'
        match 'blogs/:blog_id/*permalink',              :to => "posts#internal", :as => :blog_post
      end

      @site = Site.create!(:name => 'site', :title => 'site', :host => 'example.org', :sections_attributes => [{
        :type => 'Blog', :name => 'home', :posts_attributes => [{ :title => 'first post' }, { :title => 'second post' }]
      }])
      @blog  = site.blogs.first
      @posts = blog.posts

      super
    end

    test 'posts#index adds tags for site.title, site.name, blog and posts to response headers' do
      setup_controller(:posts)
      process_action_rendering(:index, :blog_id => blog.id) do
        site.name
        site.title
        collection.each { |post| post.title; post.body }
      end

      expected = %W(site-#{site.id}:name site-#{site.id}:title blog-#{blog.id}:posts post-#{posts.first.id} post-#{posts.second.id})
      actual   = controller.response.headers[ReferenceTracking::TAGS_HEADER]
      assert_equal expected, actual
    end
  end
end
