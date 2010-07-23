require 'adva/name'

module Adva
  class Contact < ActiveRecord::Base
    include Adva
    # include Preferable::Associations

    set_table_name 'contacts'

    composed_of :name, 
      :allow_nil  => false,
      :class_name => 'Adva::Name',
      :mapping    => [ %w(prefix prefix), %w(first_name given), %w(middle_name additional), %w(last_name family), %w(suffix suffix) ]

    has_many :addresses, :as => :addressable
    has_one  :preferred_address, :as => :addressable, :class_name => 'Adva::Address'
  
    delegate :extended, :street, :locality, :city, :region, :postalcode, :country, :to => :preferred_address
  
    # has_many :positions
    # has_many :orgs, :through => :positions

    validates_presence_of  :first_name, :last_name
    validates_format_of    :prefix, :first_name, :middle_name, :last_name, :suffix, :nickname, :with => FORMATS[:unicode_permissive]
    validates_format_of    :url, :with => FORMATS[:uri], :allow_blank => true
    validates_length_of    :prefix, :first_name, :middle_name, :last_name, :suffix, :maximum => 32, :allow_nil => true
    validates_inclusion_of :gender, :in => GENDERS, :allow_blank => true

    before_validation :normalize_url

    # accepts_nested_attributes_for :telephones, :emails, :allow_destroy => true, 
    #   :reject_if => proc { |attributes| attributes['value'].blank? }
    # accepts_nested_attributes_for :positions, :allow_destroy => true, 
    #   :reject_if => proc { |attributes| attributes['organization_name'].blank? }
    # # HACK since Address location is always assigned by the form, I temporarly keep it out,
    # # just to check if the other attributes are empty.
    accepts_nested_attributes_for :addresses, :allow_destroy => true,
      :reject_if => proc { |attributes| attributes.merge('location' => nil).all? {|attr, value| value.blank?} }

    def full_name
      "#{first_name} #{last_name}"
    end

    def full_name=(fullname)
      self.first_name, self.last_name = fullname.split(' ')
      fullname
    end
  
    [:extended, :street, :locality, :city, :region, :postalcode, :country].each do |attribute|
      define_method(:"#{attribute}=") do |value|
        address = preferred_address || create_preferred_address
        address.send(:"#{attribute}=", value)
      end
    end

    # def roles
    #   @roles ||= positions.map(&:role).join(", ")
    # end
    # 
    # def positions_and_organizations
    #   @positions_and_organizations ||= begin
    #     positions.map do |position|
    #       "#{position.title} #{I18n.t(:'adva.contacts.labels.at')} #{position.org.name}"
    #     end.to_sentence
    #   end
    # end
    # 
    # def to_vcard
    #   Vpim::Vcard::Maker.make2 do |maker|
    #     maker.add_name do |n|
    #       n.prefix, n.given, n.additional, n.family, n.suffix =
    #         name.prefix, name.given, name.additional, name.family, name.suffix
    #     end
    # 
    #     %w(addresses telephones emails).each do |attr|
    #       maker.card << self.send(attr).map(&:to_encoded_vcard)
    #     end
    #   end.to_s
    # end
    # alias_method :to_vcf, :to_vcard
    # 
    # def to_vcf_filename
    #   "#{short_name.downcase.gsub(" ", "_")}.vcf"
    # end
    # 
    # def bday
    #   born_on
    # end

    private

      def normalize_url
        return if url.blank?
        self.url = url.to_s.strip.downcase
        self.url = "http://" + url unless url =~ /^http/i
      end
  end
end