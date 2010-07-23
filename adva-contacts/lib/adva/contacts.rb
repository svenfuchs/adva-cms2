require 'adva'

module Adva
  GENDERS = %w(Male Female)
  LOCATIONS = %w(Home Work Other)

  FORMATS = {
    :ascii => /\A\w[\w\.\-_@]+\z/,
    :uri   => /^(http|https):\/\/[a-z0-9\_\-\.]*[a-z0-9_-]{1,}\.[a-z]{2,4}[\/\w\d\_\-\.\?\&\#]*$/i,
    :unicode_permissive => /\A[^[:cntrl:]\\<>\/&]*\z/
  }

  class Contacts < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-contacts.add_inflection_rules' do
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.irregular 'address', 'addresses'
      end
    end
    
  end
end
