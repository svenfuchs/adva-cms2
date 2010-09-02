require File.expand_path('../../test_helper', __FILE__)

module Tests
  module Core
    module Import
      module Directory
        class SiteTest < Test::Unit::TestCase
          include Setup, Adva::Static::Import::Directory::Models

          test "site.updated_record with a new root blog section" do
            setup_root_blog

            site = Site.new(root).updated_record
            site.save!

            blog = site.sections.first
            post = blog.posts.first

            assert site.valid?
            assert_equal 'ruby-i18n.org', site.host
            assert_equal 'Blog', blog.class.name
            assert_equal 'Home', blog.title
            assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
          end

          test "site.updated_record with an existing root blog section" do
            setup_root_blog_record
            setup_root_blog

            site = Site.new(root).updated_record
            site.save!

            blog = site.sections.first
            post = blog.posts.first

            assert site.valid?
            assert_equal 'ruby-i18n.org', site.host
            assert_equal 'Blog', blog.class.name
            assert_equal 'Home', blog.title
            assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
          end

          test "site.site with a new non_root blog section" do
            setup_non_root_blog

            site = Site.new(root).updated_record
            site.save!

            blog = site.sections.first
            post_1 = blog.posts.first
            post_2 = blog.posts.second

            assert site.valid?
            assert_equal 'ruby-i18n.org', site.host
            assert_equal 'Blog', blog.class.name
            assert_equal 'Blog', blog.title
            assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post_1.title
            assert_equal 'Ruby I18n Gem Hits 0 2 0', post_2.title
          end

          test "site.site with an existing non_root blog section" do
            setup_non_root_blog_record
            setup_non_root_blog

            site = Site.new(root).updated_record
            site.save!
          
            blog = site.sections.last
            post_1 = blog.posts.first
            post_2 = blog.posts.second
          
            assert site.valid?
            assert_equal 'ruby-i18n.org', site.host
            assert_equal 'Blog', blog.class.name
            assert_equal 'Blog', blog.title
            assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post_1.title
            assert_equal 'Ruby I18n Gem Hits 0 2 0', post_2.title
          end

          test "site.site with a new root page, a new non_root blog and a new non_root page section" do
            setup_root_page
            setup_non_root_blog
            setup_non_root_page

            site = Site.new(root).updated_record
            site.save!

            root = site.sections.first
            blog = site.sections.second
            post = blog.posts.first
            page = site.sections.third

            assert site.valid?
            assert_equal 'ruby-i18n.org', site.host
            assert_equal 'Blog', blog.class.name
            assert_equal 'Blog', blog.title
            assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
          end
        end
      end
    end
  end
end