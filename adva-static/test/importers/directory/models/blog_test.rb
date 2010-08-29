require File.expand_path('../../test_helper', __FILE__)

module Tests
  module Core
    module Importers
      module Directory
        class BlogTest < Test::Unit::TestCase
          include Setup, Adva::Importers::Directory::Models

          test "Blog.build finds a root blog" do
            setup_root_blog
            assert_equal 1, Section.build(root.paths).size
          end
    
          test "Blog.build finds a non_root blog" do
            setup_non_root_blog
            assert_equal 1, Section.build(root.paths).size
          end
    
          test "Blog loads index.yml if present" do
            setup_root_blog
            setup_files(['index.yml', YAML.dump('title' => 'the blog')])
            assert_equal 'the blog', Blog.new(root).title
          end
        end
      end
    end
  end
end