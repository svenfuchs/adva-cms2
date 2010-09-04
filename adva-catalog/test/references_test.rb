require File.expand_path('../test_helper', __FILE__)

module AdvaCatalogTests
  class ReferencesTest < Test::Unit::TestCase
    include TestHelper::Application

    attr_reader :site, :catalog, :products

    def setup
      setup_application do
        match 'catalogs/:id',                        :to => 'catalogs#show', :as => :catalog
        match 'catalogs/:catalog_id/products/:slug', :to => 'products#show', :as => :catalog_product
      end

      @site = Site.create!(:name => 'site', :title => 'site', :host => 'example.org',
        :account => Account.create!,
        :sections_attributes => [{ :type => 'Catalog', :title => 'home' }]
      )
      @catalog  = site.catalogs.first
      @products = [Product.create!(:account => site.account), Product.create!(:account => site.account)]

      super
    end

    test 'catalogs#show adds tags for site.title, site.name, catalog and products to response headers' do
      setup_controller(:catalogs)
      process_action_rendering(:show, :id => catalog.id) do
        current_site.name
        current_site.title
        resource.products.each { |product| product.name; product.price }
      end

      expected = %W(site-#{site.id}:name site-#{site.id}:title catalog-#{catalog.id} product-#{products.first.id} product-#{products.second.id})
      actual   = controller.response.headers[ReferenceTracking::TAGS_HEADER]
      assert_equal expected, actual
    end
  end
end