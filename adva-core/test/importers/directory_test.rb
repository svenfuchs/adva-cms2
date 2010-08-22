require File.expand_path('../directory/test_helper', __FILE__)
require 'action_controller'
require 'routing_filter'
require 'adva/routing_filters/section_root'
require 'adva/routing_filters/section_path'

module Tests
  module Core
    module Importers
      class DirectoryTest < Test::Unit::TestCase
        class PostController < ActionController::Base; end
        class PagesController < ActionController::Base; end
        class BlogsController < ActionController::Base; end

        include Tests::Core::Importers::Directory::Setup

        def setup
          # TODO fix devise to be able to load up w/o a Rails.application being present
          Rails.application = Rails::Application.send(:new)
          Rails.application.singleton_class.send(:include, Rails::Application::Configurable)
          Devise.warden_config = Rails.application.config
          super
        end

        def routes
          @routes ||= ActionDispatch::Routing::RouteSet.new.tap do |routes|
            routes.draw do
              filter :section_root, :section_path
              match 'blogs/:blog_id/:year/:month/:day/:slug', :to => "#{PostController.controller_path}#show"
              match 'pages/:id', :to => "#{PagesController.controller_path}#show"
              match 'blogs/:id', :to => "#{BlogsController.controller_path}#show"
            end
          end
        end

        def teardown
          Rails.application = nil
          super
        end

        def site
          @site ||= ::Site.first
        end

        test "import! with an empty database" do
          setup_root_blog
          Adva::Importers::Directory.new(root).import!

          site = Site.first
          blog = site.sections.first
          post = blog.posts.first

          assert_equal 'rails-i18n.org', site.host
          assert_equal 'Home', blog.title
          assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
        end

        test "import! with an existing site and root blog" do
          setup_site_record
          setup_root_blog
          Adva::Importers::Directory.new(root).import!

          site = Site.first
          blog = site.sections.first
          post = blog.posts.first

          assert_equal 'rails-i18n.org', site.host
          assert_equal 'Home', blog.title
          assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
        end

        test "import! with a root page, a blog and another page" do
          setup_root_page
          setup_non_root_blog
          setup_non_root_page
          Adva::Importers::Directory.new(root).import!

          site = Site.first
          page = site.sections.first
          blog = site.sections[1]
          post = blog.posts.first

          assert_equal 'rails-i18n.org', site.host
          assert_equal 'Home', page.title
          assert_equal 'Blog', blog.title
          assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
        end

        test "sync_file! can sync changes to /index.yml (root page)" do
          setup_site_record
          setup_root_page

          section = Page.find_by_slug('home')
          section.update_attributes!(:title => 'will be overwritten')
          section.article.update_attributes!(:body => 'will be overwritten')
          assert_equal 'will be overwritten', section.reload.title
          assert_equal 'will be overwritten', section.article.reload.body

          path = 'index.yml'
          Adva::Importers::Directory.new(root, :routes => routes).sync!(path)

          assert_equal 'Home', section.reload.title
          assert_equal 'home', section.article.reload.body
        end

        test "sync! can sync changes to /contact.yml (non-root page)" do
          setup_non_root_page_record
          setup_non_root_page

          section = Page.find_by_slug('contact')
          section.update_attributes!(:title => 'will be overwritten')
          section.article.update_attributes!(:body => 'will be overwritten')
          assert_equal 'will be overwritten', section.reload.title
          assert_equal 'will be overwritten', section.article.reload.body

          path = 'contact.yml'
          Adva::Importers::Directory.new(root, :routes => routes).sync!(path)

          assert_equal 'Contact', section.reload.title
          assert_equal 'contact', section.article.reload.body
        end

        test "sync! can sync changes to /blog.yml (non-root blog)" do
          setup_non_root_blog_record
          setup_non_root_blog

          section = Blog.find_by_slug('blog')
          section.update_attributes!(:title => 'will be overwritten')
          assert_equal 'will be overwritten', section.reload.title

          path = 'blog.yml'
          Adva::Importers::Directory.new(root, :routes => routes).sync!(path)

          assert_not_equal 'will be overwritten', section.reload.title
        end

        test "sync! can sync changes to blog/2009/07/12/ruby-i18n-gem-hits-0-2-0.yml (root blog)" do
          setup_non_root_blog_record
          setup_non_root_blog

          section = Blog.find_by_slug('blog')
          section.posts.first.update_attributes!(:body => 'will be overwritten')
          assert_equal 'will be overwritten', section.posts.first.reload.body

          path = 'blog/2008/07/31/welcome-to-the-future-of-i18n-in-ruby-on-rails.yml'
          Adva::Importers::Directory.new(root, :routes => routes).sync!(path)

          assert_not_equal 'will be overwritten', section.posts.first.reload.body
        end

        test "sync! can sync changes to 2009/07/12/ruby-i18n-gem-hits-0-2-0.yml (non-root blog)" do
          setup_root_blog_record
          setup_root_blog

          section = Blog.find_by_slug('blog')
          section.posts.first.update_attributes!(:body => 'will be overwritten')
          assert_equal 'will be overwritten', section.posts.first.reload.body

          path = '2008/07/31/welcome-to-the-future-of-i18n-in-ruby-on-rails.yml'
          Adva::Importers::Directory.new(root, :routes => routes).sync!(path)

          assert_not_equal 'will be overwritten', section.posts.first.reload.body
        end
      end
    end
  end
end