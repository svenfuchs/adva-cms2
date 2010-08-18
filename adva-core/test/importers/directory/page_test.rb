require File.expand_path('../test_helper', __FILE__)

module Tests
  module Core
    module Importers
      module Directory
        class PageTest < Test::Unit::TestCase
          include Setup

          test "Page.detect finds a root page" do
            setup_root_page
            assert_equal 1, Adva::Importers::Directory::Section.detect(root).size
          end
    
          test "Page.detect finds a non_root page" do
            setup_non_root_page
            assert_equal 1, Adva::Importers::Directory::Section.detect(root).size
          end
        end
      end
    end
  end
end