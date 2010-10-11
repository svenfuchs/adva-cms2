require File.expand_path('../test_helper', __FILE__)

module AdvaCoreTests
  class SiteTest < Test::Unit::TestCase
    attr_reader :site_params

    def setup
      @site_params = {
        :name  => 'Site 1',
        :title => 'Site title',
        :host  => 'localhost:3000',
        :sections_attributes => [ { :type => 'Page', :name => 'Home' } ]
      }
    end

    test "site creation" do
      site = Site.create(site_params)
      assert site.valid?
    end

    test "site accepts nested attributes for :section" do
      site = Site.create!(site_params)
      section = site.sections.first
      assert !section.new_record?
      assert_equal 'Page', section.type
    end

    test "site validates presence of :name" do
      site_params.delete(:name)
      assert_equal ["can't be blank"], Site.create(site_params).errors[:name]
    end

    test "site validates presence of :title" do
      site_params.delete(:title)
      assert_equal ["can't be blank"], Site.create(site_params).errors[:title]
    end

    test "site validates presence of :host" do
      site_params.delete(:host)
      assert_equal ["can't be blank"], Site.create(site_params).errors[:host]
    end

    # test "site has one home section" do
    #   site_params[:sections_attributes] << { :type => 'Page', :name => 'Contact' }
    #   site = Site.create(site_params)
    #   assert_equal 'Home', site.home_section.name
    # end

    # test "site validates presence of the home section" do
    #   site_params.delete(:sections_attributes)
    #   site = Site.new(site_params)
    #   assert !site.valid?
    #   assert_equal "can't be blank", site.errors.values.flatten.first
    # end
  end
end
