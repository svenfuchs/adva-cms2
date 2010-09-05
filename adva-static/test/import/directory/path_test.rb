require File.expand_path('../test_helper', __FILE__)

module Tests
  module Core
    module Import
      module Directory
        class PathTest < Test::Unit::TestCase
          include Setup

          test "path.dirs returns directory paths" do
            assert_equal %w(images javascripts stylesheets), root.dirs.map(&:local).map(&:to_s)
          end

          test "dirs returned by path.dirs have their root populated" do
            assert_equal [''], root.dirs.map(&:root).map(&:local).map(&:to_s).uniq
          end

          test "path.files returns file paths" do
            assert_equal %w(config.ru site.yml), root.files.map { |file| File.basename(file) }
          end

          test "files returned by path.files have their root populated" do
            assert_equal [''], root.files.map(&:root).map(&:local).map(&:to_s).uniq
          end

          test "parents returns an array of parent paths" do
            path = Adva::Static::Import::Directory::Path.new(root.join('foo/bar/baz.yml'))
            assert_equal %w(foo foo/bar), path.parents.map(&:local).map(&:to_s)
          end

          test "self_and_parents returns an array of parent paths including self" do
            path = Adva::Static::Import::Directory::Path.new(root.join('foo/bar/baz.yml'))
            assert_equal %w(foo foo/bar foo/bar/baz), path.self_and_parents.map(&:local).map(&:to_s)
          end
        end
      end
    end
  end
end