require File.expand_path('../../test_helper', __FILE__)

module Tests
  module Core
    module Import
      module Directory
        class PageTest < Test::Unit::TestCase
          include Setup, Adva::Static::Import::Directory::Models

          test "Page.build builds a root page" do
            setup_root_page
            assert_equal 1, Section.build(root.paths).size
          end

          test "Page.build builds a non_root page" do
            setup_non_root_page
            assert_equal 1, Section.build(root.paths).size
          end

          test "Page.build builds a page nested in a non-root page" do
            setup_non_root_page
            setup_files(['contact/mailer.yml', YAML.dump(:body => 'contact/mailer')])
            assert_equal 2, Section.build(root.paths).size
          end

          test "Page.build builds a page nested in an implicit non-root page" do
            setup_nested_page
            pages = Section.build(root.paths)
            assert_equal 2, pages.size
            assert_equal 'contact', pages.first.source.local.to_s
            assert_equal 'contact/mailer', pages.second.source.local.to_s
          end
        end
      end
    end
  end
end