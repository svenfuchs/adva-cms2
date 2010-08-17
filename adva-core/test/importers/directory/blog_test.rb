require File.expand_path('../test_helper', __FILE__)

module Tests
  module Core
    module Importers
      module Directory
        class BlogTest < Test::Unit::TestCase
          include Setup

          test "Blog.accept? detects a root blog by archived permalink style subdirs" do
            setup_root_blog
            assert Adva::Importers::Directory::Blog.accept?(root)
          end

          test "Blog.accept? detects a non-root blog by archived permalink style subdirs" do
            setup_non_root_blog
            assert Adva::Importers::Directory::Blog.accept?(root.join('blog'))
          end

          test "Blog loads index.yml if present" do
            setup_root_blog
            setup_files(['index.yml', YAML.dump('title' => 'the blog')])
            assert_equal 'the blog', Adva::Importers::Directory::Blog.new(root).title
          end

          test "Post defaults created_at to the path's archive date" do
            setup_root_blog
            post = Adva::Importers::Directory::Blog.new(root).section.posts.first
            assert_equal DateTime.civil(2008, 7, 31), post.created_at
          end

          test "Post loads [article].yml files" do
            setup_root_blog
            setup_files(['2008/07/18/finally-ruby-on-rails-gets-internationalized.yml', YAML.dump(
              'title' => 'Finally. Ruby on Rails gets internationalized',
              'body'  => 'In hindsight we\'ve initially tried to accomplish way to much.'
            )])
            
            post = Adva::Importers::Directory::Blog.new(root).section.posts.first
            assert_equal 'Finally. Ruby on Rails gets internationalized', post.title
          end
        end
      end
    end
  end
end