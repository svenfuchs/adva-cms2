require 'adva'
require 'attributes'

module Adva
  class Attributes < ::Rails::Engine
    include Adva::Engine

    # initializer 'adva-attributes.require_section_types' do
    #   config.to_prepare { require_dependency 'page' }
    # end
  end
end
