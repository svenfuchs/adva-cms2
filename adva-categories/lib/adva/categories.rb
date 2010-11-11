require 'adva/core'
require 'adva/active_record/categorizable'
require 'adva/views/categories_tab'

module Adva
  class Categories < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-categories.configure_routing_filters' do
      RoutingFilter::SectionRoot.anchors << 'categories'
    end
  end
end
