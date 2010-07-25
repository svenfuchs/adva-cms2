require File.expand_path('../../test_helper', __FILE__)
require 'adva/address'

module AdvaContacts
  class AddressTest < Test::Unit::TestCase
    test "can create a valid address" do
      attributes = {
        :street  => 'August-Bebel-Strasse 27', 
        :zipcode => '14482',
        :city    => 'Potsdam',
        :country => 'Germany'
      }
      address = Adva::Address.create(attributes)

      assert address.valid?
      assert_equal attributes[:street], address.street
      assert_equal attributes[:zipcode], address.zipcode
      assert_equal attributes[:city], address.city
      assert_equal attributes[:country], address.country
    end
  end
end

# class AddressTest < ActiveSupport::TestCase
#   include ContactsTestHelper
#
#   test "should belong to addressable" do
#     address.should belong_to(:addressable)
#   end
#
#   test "should create" do
#     assert_difference "Address.count" do
#       create_address
#     end
#   end
#
#   test "should validate length of extended" do
#     address.should validate_length_of(:extended, :within => 0..255) #:maximum => 255
#   end
#
#   test "should validate length of street" do
#     address.should validate_length_of(:street, :within => 0..255) #:maximum => 255
#   end
#
#   test "should validate length of locality" do
#     address.should validate_length_of(:locality, :within => 0..255) #:maximum => 255
#   end
#
#   test "should validate length of region" do
#     address.should validate_length_of(:region, :within => 0..255) #:maximum => 255
#   end
#
#   test "should validate length of zipcode" do
#     address.should validate_length_of(:zipcode, :within => 0..255) #:maximum => 255
#   end
#
#   test "should validate length of country" do
#     address.should validate_length_of(:country, :within => 0..255) #:maximum => 255
#   end
#
#   test "should validate inclusion of country in available countries" do
#     assert_no_difference "Address.count" do
#       create_address(:country => 'Unknonw').should_not be_valid
#     end
#   end
#
#   test "should allow nil country" do
#     create_address(:country => nil).should be_valid
#   end
#
#   test "should validate inclusion of location" do
#     assert_no_difference "Address.count" do
#       create_address(:location => 'Unknonw').should_not be_valid
#       create_address(:location => nil).should_not be_valid
#     end
#   end
#
#   test "should validate format of delivery" do
#     assert_no_difference "Address.count" do
#       create_address(:delivery => invalid_unicode_string).should_not be_valid
#     end
#   end
#
#   test "should validate format of pobox" do
#     assert_no_difference "Address.count" do
#       create_address(:pobox => invalid_unicode_string).should_not be_valid
#     end
#   end
#
#   test "should validate format of zipcode" do
#     assert_no_difference "Address.count" do
#       create_address(:zipcode => "11").should_not be_valid
#       create_address(:zipcode => "abc").should_not be_valid
#     end
#   end
#
#   test "should allow nil zipcode" do
#     create_address(:zipcode => nil).should be_valid
#   end
#
#   test "should allow to set as preferred" do
#     create_address(:preferred => true).preferred.should be_true
#   end
#
#   test "should automatically set as preferred if unique address" do
#     contact = create_contact(:addresses_attributes => [address_attributes])
#     contact.addresses.preferred.should_not be_nil
#   end
#
#   test "should automatically set as preferred first address if create multiple on empty addressable scope" do
#     contact = create_contact(:addresses_attributes => [address_attributes, address_attributes])
#     contact.addresses.preferred.should_not be_nil
#
#     contact.addresses.first.preferred?.should be_true
#     contact.addresses.last.preferred?.should be_false
#   end
#
#   test "should keep preferred after addressable update" do
#     contact = create_contact(:addresses_attributes => [address_attributes])
#     contact.addresses.preferred.should_not be_nil
#
#     contact.update_attribute "prefix", "Mr."
#     contact.addresses.preferred.should_not be_nil
#   end
#
#   test "should automatically set as preferred if previous preferred is removed" do
#     contact = create_contact(:addresses_attributes => [address_attributes, address_attributes])
#     contact.addresses.preferred.should_not be_nil
#
#     address = contact.addresses.first
#     contact.addresses.delete(address)
#     contact.addresses(true).preferred.should_not be_nil
#   end
#
#   test "to_vcard" do
#     address = create_extended_address
#     vcard_address = address.to_vcard
#
#     vcard_address.should be_instance_of(Vpim::Vcard::Address)
#     vcard_address.pobox.should      be(address.pobox)
#     vcard_address.extended.should   be(address.extended)
#     vcard_address.street.should     be(address.street)
#     vcard_address.locality.should   be(address.locality)
#     vcard_address.region.should     be(address.region)
#     vcard_address.zipcode.should be(address.zipcode)
#     vcard_address.country.should    be(address.country)
#     vcard_address.preferred.should  be(address.preferred)
#     vcard_address.location.should include(address.location.downcase)
#     vcard_address.delivery.should include(address.delivery.downcase)
#   end
#
#   test "to_encoded_vcard" do
#     create_extended_address.to_encoded_vcard.to_s.should be("ADR;TYPE=work,home:P.O. BOX 534;1 Infinite Looooooop;1 Infinite Loop;Cupert\n ino;California;95014;United States\n")
#   end
# end
