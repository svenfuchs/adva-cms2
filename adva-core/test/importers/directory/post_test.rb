require File.expand_path('../test_helper', __FILE__)

module Tests
  module Core
    module Importers
      module Directory
        class PostTest < Test::Unit::TestCase
          include Setup

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