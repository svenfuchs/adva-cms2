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
      ActionController::Base.skip_before_filter(:authenticate_user!)
      super

      @site = Factory(:site)
      @page = site.pages.first
    end

    test 'tracks references to site.title, site.name and resource and adds tags to response headers' do
      process_action_rendering(:show, :id => page.id) do
        site.name
        site.title
        resource.name
      end
      tags = controller.response.headers[ReferenceTracking::TAGS_HEADER]
      assert_equal %W(site-#{site.id}:name site-#{site.id}:title page-#{page.id}), tags
    end
  end
end
