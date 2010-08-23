require 'adva/engine'
require 'routing_filter'
require 'adva/routing_filters/section_root'

module Adva
  class Catalog < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-catalog.require_section_types' do
      config.to_prepare { require_dependency 'catalog' }
    end
  end
end

RoutingFilter::SectionRoot.anchors_segments['Catalog'] = 'products'