require 'adva'

module Adva
  class Assets < ::Rails::Engine
    include Adva::Engine

    # initializer 'adva-assets.require_section_types' do
    #   config.to_prepare { require_dependency 'page' }
    # end
  end
end
