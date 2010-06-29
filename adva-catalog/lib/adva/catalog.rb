require 'adva-core'

module Adva
  class Catalog < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-catalog.require_section_types' do
      require 'catalog'
    end

    initializer 'adva-catalog.add_catalogs_to_site' do
      Site.has_many :catalogs
    end
  end
end