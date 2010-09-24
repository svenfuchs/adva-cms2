require File.expand_path('../../test_helper', __FILE__)

require 'core_ext/ruby/file/basename_multiple_extensions'

module AdvaStatic
  class ImportPageTest < Test::Unit::TestCase
    include Adva::Static::Import

    attr_reader :source

    def setup
      @source = Source.new('foo/page.html', 'path/to/import')
    end

    test "recognizes a Page importer from a page path (e.g. /page.html)" do
      paths = [source]
      pages = Model::Page.recognize(paths)

      assert paths.empty?
      assert pages.first.is_a?(Model::Page)
    end

    test "has Page attributes" do
      page = Model::Page.new(source)
      expected = {
        :site_id => '',
        :type    => 'Page',
        :path    => 'foo/page',
        :slug    => 'page',
        :name    => 'Page',
        :article_attributes => {
          :title => 'Page',
          :body  => ''
        }
      }
      assert_equal expected, page.attributes
    end

    test "finds a Page model corresponding with a Page importer" do
    end

    test "returns request parameters necessary to create a new Page" do
    end

    test "returns request parameters necessary to update an existing Page" do
    end
  end
end