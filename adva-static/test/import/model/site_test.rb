require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportModelSiteTest < Test::Unit::TestCase
    include Adva::Static::Import::Model, TestHelper::Static

    test "has Site attributes (given a site.yml file)" do
      setup_file 'site.yml', YAML.dump(:host => 'host', :name => 'name', :title => 'title')
      site = Site.new(import_dir)
      expected = { :host => 'host', :name => 'name', :title => 'title' }
      assert_equal expected, site.attributes
    end

    test "has Site attributes (given no site.yml file)" do
      setup_file 'site.yml'
      site = Site.new(import_dir)
      expected = { :host => 'import', :name => 'Import', :title => 'Import' }
      assert_equal expected, site.attributes
    end

    test "creates a Site new record" do
      setup_file 'site.yml', YAML.dump(:host => 'host', :name => 'name', :title => 'title')
      site = Site.new(import_dir)
      site.update!
      expected = { 'host' => 'host', 'name' => 'name', 'title' => 'title' }
      assert_equal expected, site.record.attributes.slice('host', 'name', 'title')
    end

    test "finds a Site record corresponding to a Post source" do
      setup_file 'site.yml', YAML.dump(:host => 'ruby-i18n.org', :name => 'name', :title => 'title')
      setup_site_record
      site = Site.new(import_dir)
      assert site.record.persisted?
    end

    test 'given an empty import root directory it adds a Home page section' do
      assert_equal 'Home', Site.new(import_dir).sections.first.attributes[:name]
    end
  end
end
