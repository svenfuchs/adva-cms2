require 'adva/engine'

module Adva
  class Catalog < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-catalog.require_section_types' do
      config.to_prepare { require_dependency 'catalog' }
    end
  end
end