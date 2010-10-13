require 'adva'

module Adva
  class Categories < ::Rails::Engine
    include Adva::Engine
  end
end

RoutingFilter::SectionRoot.anchors_segments['Blog'] << ['/categories']

