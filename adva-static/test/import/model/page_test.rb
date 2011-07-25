require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportModelPageTest < Test::Unit::TestCase
    include Adva::Static::Import::Model, TestHelper::Static

    test "has Page attributes" do
      setup_files(['home.yml', YAML.dump(:name => 'Page name')])
      page = Page.new(import_dir.join('home.yml'))
      expected = { :type => 'Page', :name => 'Page name', :slug => 'page-name' }
      assert_equal expected, page.attributes
    end

    test "creates a new Page record" do
      setup_files(['home.yml', YAML.dump(:name => 'name', :body => 'body')])
      page = Page.new(import_dir.join('home.yml'))
      expected = { 'type' => 'Page', 'name' => 'name', 'slug' => 'name' }
      assert_equal expected, page.updated_record.attributes.slice('type', 'name', 'slug')
    end

    test "finds and updates a Page record corresponding to a Page source" do
      setup_root_page_record
      setup_files(['home.yml', ''])
      page = Page.new(import_dir.join('home.yml'))
      assert page.record.persisted?
    end
  end
end
