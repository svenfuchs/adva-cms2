require File.expand_path('../directory/test_helper', __FILE__)
require 'action_controller'
require 'routing_filter'
require 'adva/routing_filters/section_root'

module Tests
  module Core
    module Importers
      class DirectoryTest < Test::Unit::TestCase
        class PostController < ActionController::Base; end
      
        include Tests::Core::Importers::Directory::Setup
        
        attr_reader :routes
      
        def setup
          # TODO fix devise to be able to load up w/o a Rails.application being present
          Rails.application = Rails::Application.send(:new)
          Rails.application.singleton_class.send(:include, Rails::Application::Configurable)
          Devise.warden_config = Rails.application.config
          
          @routes = ActionDispatch::Routing::RouteSet.new
          routes.draw do
            filter :section_root
            match 'blogs/:blog_id/:year/:month/:day/:slug', :to => "#{PostController.controller_path}#show"
          end
          super
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
          Adva::Importers::Directory.new(root, :routes => routes).import!
          
          site = Site.first
          blog = site.sections.first
          post = blog.posts.first
          
          assert_equal 'rails-i18n.org', site.host
          assert_equal 'Home', blog.title
          assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
        end
      
        test "import! with an existing site and root blog" do
          ::Site.create!(:host => 'rails-i18n.org', :name => 'name', :title => 'title', :sections_attributes => [
            { :type => 'Page', :title => 'Home' }
          ])
          setup_root_blog
          Adva::Importers::Directory.new(root, :routes => routes).import!
          
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
          Adva::Importers::Directory.new(root, :routes => routes).import!
          
          site = Site.first
          page = site.sections.first
          blog = site.sections[1]
          post = blog.posts.first

          assert_equal 'rails-i18n.org', site.host
          assert_equal 'Home', page.title
          assert_equal 'Blog', blog.title
          assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
        end
      end
    end
  end
end