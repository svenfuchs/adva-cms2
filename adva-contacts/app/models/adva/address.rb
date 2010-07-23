module Adva
  class Address < ActiveRecord::Base
    include Adva
    # include Adva::Preferable

    set_table_name 'contact_addresses'

    belongs_to :addressable, :polymorphic => :true

    validates_format_of    :pobox, :delivery, :with => FORMATS[:ascii], :allow_nil => true
    validates_format_of    :zipcode, :with => /^\d{5}$/, :allow_nil => true
    validates_length_of    :extended, :street, :city, :region, :zipcode, :country, :maximum => 255, :allow_nil => true
    validates_inclusion_of :location, :in => LOCATIONS, :allow_nil => true
    # validates_inclusion_of :country,  :in => I18n.t(:'adva.contacts.countries').values, :allow_nil => true

    def locality
      self.city
    end

    def locality=(locality)
      self.city = locality
    end

    def postalcode
      self.zipcode
    end

    def postalcode=(postalcode)
      self.zipcode = postalcode
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