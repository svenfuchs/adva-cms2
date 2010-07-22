require 'adva'

module Adva
  class Contact < ::Rails::Engine
    include Adva::Engine

    # initializer 'adva-contacts.require_section_types' do
    #   config.to_prepare { require_dependency 'page' }
    # end
  end
end
