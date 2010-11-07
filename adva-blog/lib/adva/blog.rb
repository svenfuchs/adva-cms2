require 'adva/core'
require 'adva/engine'

require 'routing_filter'
require 'adva/routing_filters/section_root'

require 'action_controller' # really should be in truncate_html
require 'truncate_html'

module Adva
  class Blog < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-blog.require_section_types' do
      config.to_prepare { require_dependency 'blog' }
    end

    initializer 'adva-blog.configure_routing_filters' do
      RoutingFilter::SectionRoot.anchors << '\d{4}'
    end

    initializer 'adva-blog.register_asset_expansions' do
      ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion(
        :default => %w( adva-blog/default/styles )
      )
    end
  end
end

