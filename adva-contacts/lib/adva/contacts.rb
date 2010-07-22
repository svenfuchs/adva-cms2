require 'adva'

module Adva
  class Contact < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-contacts.add_inflection_rules' do
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.irregular 'address', 'addresses'
      end
    end
    
  end
end
