require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportSourceSiteTest < Test::Unit::TestCase
    include Adva::Static::Import::Source, TestHelper::Static

    def site
      Site.new(import_dir)
    end

    test "given a site file import/site.yml it reads the file" do
      setup_site
      assert_equal('ruby-i18n.org', site.data.host)
    end

    test "data includes attributes and association data" do
      setup_site
      assert_equal({ :host => 'ruby-i18n.org', :name => 'name', :title => 'title', :sections => [] }, site.data)
    end
  end
end
