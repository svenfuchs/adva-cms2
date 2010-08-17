require File.expand_path('../test_helper', __FILE__)

module Tests
  module Core
    module Importers
      module Directory
        class PathTest < Test::Unit::TestCase
          include Setup

          test "path.dirs returns directory paths" do
            assert_equal %w(images javascripts stylesheets), root.dirs.map(&:local_path).map(&:to_s)
          end
  
          test "dirs returned by path.dirs have their root populated" do
            assert_equal [''], root.dirs.map(&:root).map(&:local_path).map(&:to_s).uniq
          end
  
          test "path.files returns file paths" do
            assert_equal %w(config.ru), root.files.map { |file| File.basename(file) }
          end
  
          test "files returned by path.files have their root populated" do
            assert_equal [''], root.files.map(&:root).map(&:local_path).map(&:to_s).uniq
          end
        end
      end
    end
  end
end