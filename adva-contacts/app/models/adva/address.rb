module Adva
  class Address < ActiveRecord::Base
    include Adva
    # include Adva::Preferable
    
    set_table_name 'contact_addresses'

    belongs_to :addressable, :polymorphic => :true

    validates_format_of    :pobox, :delivery, :with => FORMATS[:ascii], :allow_nil => true
    validates_format_of    :postalcode, :with => /^\d{5}$/, :allow_nil => true
    validates_length_of    :extended, :street, :locality, :region, :postalcode, :country, :maximum => 255, :allow_nil => true
    validates_inclusion_of :location, :in => LOCATIONS, :allow_nil => true
    # validates_inclusion_of :country,  :in => I18n.t(:'adva.contacts.countries').values, :allow_nil => true

    def city
      self.locality
    end
  
    def city=(city)
      self.locality = city
    end
  
    def to_vcard
      Vpim::Vcard::Address.new.tap do |a|
        a.pobox, a.extended, a.street, a.locality, a.region, a.postalcode, a.country, a.preferred =
          pobox.to_s, extended.to_s, street.to_s, locality.to_s, region.to_s, postalcode.to_s, country.to_s, preferred

        a.location = [ location.downcase ] if location
        a.delivery = [ delivery.downcase ] if delivery
      end
    end

    def to_encoded_vcard
      to_vcard.encode
    end
  end
end