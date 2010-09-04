require File.expand_path('../test_helper', __FILE__)
require 'action_controller'
require 'routing_filter'
require 'adva/routing_filters/section_root'
require 'adva/routing_filters/section_path'

module Tests
  module Core
    module Import
      class DirectoryTest < Test::Unit::TestCase
        include TestHelper::Application

        class PostController < ActionController::Base; end
        class PagesController < ActionController::Base; end
        class BlogsController < ActionController::Base; end

        include Tests::Core::Import::Directory::Setup

        def setup
          setup_application do
            filter :section_root, :section_path
            match 'pages/:id', :to => "#{PagesController.controller_path}#show"
            match 'blogs/:id', :to => "#{BlogsController.controller_path}#show"
            match 'blogs/:blog_id/:year/:month/:day/:slug', :to => "#{PostController.controller_path}#show"
            match 'admin/sites/:site_id/pages/:id', :to => 'admin/pages#update', :as => 'admin_site_page'
          end
          super
        end

        def site
          @site ||= ::Site.first
        end

        test "run with an empty database" do
          setup_root_blog
          Adva::Static::Import::Directory.new(:source => root).run

          site = Site.first
          blog = site.sections.first
          post = blog.posts.first

          assert_equal 'ruby-i18n.org', site.host
          assert_equal 'Home', blog.title
          assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
        end

        test "run with an existing site and root blog" do
          setup_site_record
          Page.first.destroy
          setup_root_blog
          Adva::Static::Import::Directory.new(:source => root).run

          blog = site.sections.first
          post = blog.posts.first

          assert_equal 'ruby-i18n.org', site.host
          assert_equal 'Home', blog.title
          assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
        end

        test "run with a root page, a blog and another page" do
          setup_root_page
          setup_non_root_blog
          setup_non_root_page
          Adva::Static::Import::Directory.new(:source => root).run

          site = Site.first
          page = site.sections.first
          blog = site.sections[1]
          post = blog.posts.first

          assert_equal 'ruby-i18n.org', site.host
          assert_equal 'Home', page.title
          assert_equal 'Blog', blog.title
          assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
        end

        test "run with a root page and a nested page (implicit creation)" do
          setup_root_page
          setup_nested_page
          Adva::Static::Import::Directory.new(:source => root).run

          site    = Site.first
          page    = site.sections.first
          contact = site.sections.second
          mailer  = site.sections.third

          assert_equal 'ruby-i18n.org', site.host
          assert_equal 'Home', page.title
          assert_equal 'Contact', contact.title
          assert_equal 'Mailer', mailer.title
        end

        test "import!(path) syncs changes to /index.yml (existing root page)" do
          setup_site_record
          setup_root_page

          section = Page.find_by_slug('home')
          section.update_attributes!(:title => 'will be overwritten')
          section.article.update_attributes!(:body => 'will be overwritten')
          assert_equal 'will be overwritten', section.reload.title
          assert_equal 'will be overwritten', section.article.reload.body

          path = 'index.yml'
          Adva::Static::Import::Directory.new(:source => root).import!(path)

          assert_equal 'Home', section.reload.title
          assert_equal 'home', section.article.reload.body
        end

        test "import!(path) syncs changes to /contact.yml (existing non-root page)" do
          setup_non_root_page_record
          setup_non_root_page

          section = Page.find_by_slug('contact')
          section.update_attributes!(:title => 'will be overwritten')
          section.article.update_attributes!(:body => 'will be overwritten')
          assert_equal 'will be overwritten', section.reload.title
          assert_equal 'will be overwritten', section.article.reload.body

          path = 'contact.yml'
          Adva::Static::Import::Directory.new(:source => root).import!(path)

          assert_equal 'Contact', section.reload.title
          assert_equal 'contact', section.article.reload.body
        end

        test "import!(path) syncs changes to /contact.yml (not yet existing non-root page)" do
          setup_site_record
          setup_non_root_page

          path = 'contact.yml'
          Adva::Static::Import::Directory.new(:source => root).import!(path)

          section = Page.find_by_slug('contact')
          assert_equal 'Contact', section.reload.title
          assert_equal 'contact', section.article.reload.body
        end

        test "import!(path) syncs changes to blog/2009/07/12/ruby-i18n-gem-hits-0-2-0.yml (existing root blog post)" do
          setup_non_root_blog_record
          setup_non_root_blog

          section = Blog.find_by_slug('blog')
          section.posts.first.update_attributes!(:body => 'will be overwritten')
          assert_equal 'will be overwritten', section.posts.first.reload.body

          path = 'blog/2008/07/31/welcome-to-the-future-of-i18n-in-ruby-on-rails.yml'
          Adva::Static::Import::Directory.new(:source => root).import!(path)

          assert_not_equal 'will be overwritten', section.posts.first.reload.body
        end

        test "import!(path) syncs changes to 2009/07/12/ruby-i18n-gem-hits-0-2-0.yml (existing non-root blog post)" do
          setup_root_blog_record
          setup_root_blog

          section = Blog.find_by_slug('home')
          section.posts.first.update_attributes!(:body => 'will be overwritten')
          assert_equal 'will be overwritten', section.posts.first.reload.body

          path = '2008/07/31/welcome-to-the-future-of-i18n-in-ruby-on-rails.yml'
          Adva::Static::Import::Directory.new(:source => root).import!(path)

          assert_not_equal 'will be overwritten', section.posts.first.reload.body
        end

        test "request returns what's needed to be PUTed to import the model" do
          setup_site_record
          setup_root_page

          site_id = Site.first.id.to_s
          page_id = Page.first.id.to_s
          article_id = Page.first.article.id.to_s

          request = Adva::Static::Import::Directory.new(:source => root).request_for('/index.yml')
          input   = ::Rack::Utils.build_nested_query(request.params)
          request = Rack::Request.new(Rack::MockRequest.env_for(request.path, :method => 'POST', :input => input))

          params  = { '_method' => 'put', 'page' => {
            'id' => page_id, 'site_id' => site_id, 'type' => 'Page', 'title' => 'Home',  'path' => 'home',
            'article_attributes' => { 'id' => article_id, 'title' => 'Home', 'body' => 'home' }
          } }
          assert_equal params, request.params
          assert_equal "/admin/sites/#{site_id}/pages/#{page_id}", request.path
        end
      end
    end
  end
end