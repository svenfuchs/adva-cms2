require File.expand_path('../test_helper', __FILE__)

module Tests
  module Core
    module Importers
      module Directory
        class BlogTest < Test::Unit::TestCase
          include Setup

          test "Blog.build finds a root blog" do
            setup_root_blog
            assert_equal 1, Adva::Importers::Directory::Section.build(root).size
          end
    
          test "Blog.build finds a non_root blog" do
            setup_non_root_blog
            assert_equal 1, Adva::Importers::Directory::Section.build(root).size
          end
    
          test "Blog loads index.yml if present" do
            setup_root_blog
            setup_files(['index.yml', YAML.dump('title' => 'the blog')])
            assert_equal 'the blog', Adva::Importers::Directory::Blog.new(root).title
          end
        end
      end
    end
  end
end