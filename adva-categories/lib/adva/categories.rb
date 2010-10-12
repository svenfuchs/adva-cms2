require 'adva'

module Adva
  class Categories < ::Rails::Engine
    include Adva::Engine

    # initializer 'adva-categories.require_section_types' do
    #   config.to_prepare { require_dependency 'page' }
    # end
  end
end
