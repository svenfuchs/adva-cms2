require File.expand_path('../test_helper', __FILE__)

module Tests
  module Core
    module Importers
      module Directory
        class SiteTest < Test::Unit::TestCase
          include Setup
    
          test "site.site returns a site with a root blog section" do
            setup_root_blog
      
            site = Adva::Importers::Directory::Site.new(root).site
            blog = site.sections.first
            post = blog.posts.first

            assert site.valid?
            assert_equal 'rails-i18n.org', site.host
            assert_equal Blog, blog.class
            assert_equal 'Home', blog.title
            assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
          end
    
          test "site.site returns a site with a non_root blog section" do
            setup_non_root_blog
      
            site = Adva::Importers::Directory::Site.new(root).site
            blog = site.sections.first
            post = blog.posts.first
      
            assert site.valid?
            assert_equal 'rails-i18n.org', site.host
            assert_equal Blog, blog.class
            assert_equal 'Blog', blog.title
            assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
          end
        
          # test "site equal?" do
          #   setup_root_blog
          #   site = ::Site.create!(:host => 'rails-i18n.org', :name => 'rails-i18n.org', :title => 'rails-i18n.org', 
          #     :sections_attributes => [{ :title => 'Home' }])
          #   p site.attributes # == Site.new(root).record
          # end
        end
      end
    end
  end
end