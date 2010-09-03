require File.expand_path('../test_helper', __FILE__)

module AdvaCoreTests
  class ReferencesTest < Test::Unit::TestCase
    include TestHelper::Application

    attr_reader :site, :page
    
    def setup
      setup_application do
        match 'admin/sites/:site_id/pages/:id', :to => 'admin/pages#show', :as => 'admin_site_page'
      end
      setup_controller(:pages)

      @site = Site.create!(:name => 'site', :title => 'site', :host => 'example.org', :sections_attributes => [{ :type => 'Page', :title => 'home' }])
      @page = site.pages.first

      super
    end
    
    test 'pages#show adds tags for site.title, site.name and page to response headers' do
      process_action_rendering(:show, :id => page.id) do
        current_site.name
        current_site.title
        resource.title
      end

      expected = %W(site-#{site.id}:name site-#{site.id}:title page-#{page.id})
      actual   = controller.response.headers[ReferenceTracking::TAGS_HEADER]
      assert_equal expected, actual
    end
  end
end