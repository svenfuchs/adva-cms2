require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportPageTest < Test::Unit::TestCase
    include Adva::Static::Import::Model, TestHelper::Static

    test "recognizes a Page importer from a page path (e.g. /page.html)" do
      sources = [source('page.html')]
      pages = Page.recognize(sources)
      assert sources.empty?
      assert_equal ['page'], pages.map(&:path)
    end

    test "recognizes nested directories from a page path (e.g. wiki/page.html)" do
      pages = Page.recognize([source('wiki/page.html')])
      assert_equal ['wiki', 'wiki/page'], pages.map(&:path)
    end

    test "has Page attributes" do
      page = Page.new(source('home/nested.yml'))
      expected = { :site_id => '', :type => 'Page', :path => 'home/nested', :slug => 'nested', :name => 'Nested', :body  => '' }
      assert_equal expected, page.attributes
    end

    test "loads attributes from the source file (w/ an index page)" do
      setup_root_page
      page = Page.new(source('index.yml'))
      expected = { :site_id => '', :type => 'Page', :path => 'home', :slug => 'home', :name => 'Home', :body  => 'home' }
      assert_equal expected, page.attributes
    end

    test "loads attributes from the source file (w/ a non-index page)" do
      setup_non_root_page
      page = Page.new(source('contact.yml'))
      expected = { :site_id => '', :type => 'Page', :path => 'contact', :slug => 'contact', :name => 'Contact', :body  => 'contact' }
      assert_equal expected, page.attributes
    end

    test "finds a Page model corresponding to a Page importer (w/ an index page)" do
      setup_root_page_record
      page = Page.new(source('index.yml'))
      assert_equal ::Page.find_by_path('home'), page.record
    end

    test "finds a Page model corresponding to a Page importer (w/ a non-index page)" do
      setup_non_root_page_record
      page = Page.new(source('contact.yml'))
      assert_equal ::Page.find_by_path('contact'), page.record
    end

    test "prefers a :name metadata attribute over the file basename as a source for the slug" do
      setup_files(['index.yml', YAML.dump(:name => 'Page')])
      page = Page.recognize([source('index.yml')]).first
      assert_equal 'page', page.slug
    end

    test "prefers a :name metadata attribute over the file basename as a source for the name" do
      setup_files(['index.yml', YAML.dump(:name => 'Page')])
      page = Page.recognize([source('index.yml')]).first
      assert_equal 'Page', page.name
    end
  end
end
