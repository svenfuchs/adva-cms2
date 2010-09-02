require File.expand_path('../../test_helper', __FILE__)

module Tests
  module Core
    module Import
      module Directory
        class PostTest < Test::Unit::TestCase
          include Setup, Adva::Static::Import::Directory::Models

          test "Post defaults created_at to the path's archive date" do
            setup_root_blog

            path = root.join('2008/07/31/welcome-to-the-future-of-i18n-in-ruby-on-rails.yml')
            assert_equal DateTime.civil(2008, 7, 31), Post.new(path).created_at
          end

          test "Post loads [article].yml files" do
            setup_root_blog

            path = root.join('2008/07/18/finally-ruby-on-rails-gets-internationalized.yml')
            setup_files([path, YAML.dump(
              'title' => 'Finally. Ruby on Rails gets internationalized',
              'body'  => 'In hindsight we\'ve initially tried to accomplish way to much.'
            )])
            
            assert_equal 'Finally. Ruby on Rails gets internationalized', Post.new(path).title
          end
        end
      end
    end
  end
end