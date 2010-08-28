require File.expand_path('../test_helper', __FILE__)
require 'action_controller'
require 'routing_filter'
require 'adva/routing_filters/section_root'
require 'adva/routing_filters/section_path'

module Tests
  module Core
    module Importers
      class RequestTest < Test::Unit::TestCase
        include Tests::Core::Importers::Directory::Setup
        
        attr_reader :routes

        def setup
          # TODO fix devise to be able to load up w/o a Rails.application being present
          Rails.application = Rails::Application.send(:new)
          Rails.application.singleton_class.send(:include, Rails::Application::Configurable)
          Devise.warden_config = Rails.application.config

          @routes ||= ActionDispatch::Routing::RouteSet.new.tap do |routes|
            routes.draw do
              filter :section_root, :section_path
              match 'pages/:id', :to => 'pages#show'
              match 'admin/sites/:site_id/pages/:id', :to => 'admin/pages#update', :as => 'admin_site_page'
            end
            Admin::BaseController.send(:include, routes.url_helpers)
          end
          super
        end

        def teardown
          Rails.application = nil
          super
        end

        test 'path returns a complete path w/ query string that can be posted to import the model' do
          setup_site_record
          setup_root_page
          
          site_id = Site.first.id.to_s
          page_id = Page.first.id.to_s
          
          import  = Adva::Importers::Directory::Import.new(root, '/', :routes => routes)
          path    = import.request.path
          params  = import.request.params
          request = ActionDispatch::TestRequest.new(Rack::MockRequest.env_for(path, :input => params))

          params  = { 'page' => {'title' => '', 'path' => '' } }
          assert_equal params, request.params
          assert_equal "/admin/sites/#{site_id}/pages/#{page_id}", request.path
        end
      end
    end
  end
end