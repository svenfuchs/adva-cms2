require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportSourcePageTest < Test::Unit::TestCase
    include Adva::Static::Import::Source, TestHelper::Static

    def page
      Site.new(import_dir).sections.last
    end

    test 'given an empty import root directory it recognizes a Home page' do
      assert_equal 'Home', Page.new(import_dir).data.name
    end

    test 'given a root page file index.yml it recognizes a page and reads the file' do
      setup_file 'index.yml', YAML.dump(:name => 'name')
      assert page.is_a?(Page)
      assert_equal 'name', page.data.name
    end

    test 'given a root page file index.yml the page name defaults to "Home"' do
      setup_file 'index.yml'
      assert page.is_a?(Page)
      assert_equal 'Home', page.data.name
    end

    test 'given a non-root page file contact.yml it recognizes a page and reads the file' do
      setup_file 'contact.yml', YAML.dump(:name => 'name')
      assert page.is_a?(Page)
      assert_equal 'name', page.data.name
    end

    test 'given a non-root page file contact.yml the page name defaults to "Contact"' do
      setup_file 'contact.yml'
      assert page.is_a?(Page)
      assert_equal 'Contact', page.data.name
    end

    test 'given a non-root page file contact/index.yml it recognizes a page and reads the file' do
      setup_file 'contact/index.yml', YAML.dump(:name => 'name')
      assert page.is_a?(Page)
      assert_equal 'name', page.data.name
    end

    test 'given a non-root page file contact/index.yml the page name defaults to "Contact"' do
      setup_file 'contact/index.yml'
      assert page.is_a?(Page)
      assert_equal 'Contact', page.data.name
    end

    test 'given a nested page file nested/contact.yml it recognizes a page and reads the file' do
      setup_file 'nested/contact.yml', YAML.dump(:name => 'name')
      assert page.is_a?(Page)
      assert_equal 'name', page.data.name
    end

    test 'given a nested page file nested/contact.yml the page name defaults to "Contact"' do
      setup_file 'nested/contact.yml'
      assert page.is_a?(Page)
      assert_equal 'Contact', page.data.name
    end

    test 'given a nested page file nested/contact/index.yml it recognizes a page and reads the file' do
      setup_file 'nested/contact/index.yml', YAML.dump(:name => 'name')
      assert page.is_a?(Page)
      assert_equal 'name', page.data.name
    end

    test 'given a nested page file nested/contact/index.yml the page name defaults to "Contact"' do
      setup_file 'nested/contact/index.yml'
      assert page.is_a?(Page)
      assert_equal 'Contact', page.data.name
    end
  end
end


