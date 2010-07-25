require File.expand_path('../../test_helper', __FILE__)

require 'adva/address'
require 'address'

module AdvaCart
  class AddressTest < Test::Unit::TestCase
    test "can create a valid address" do
      attributes = {
        :name       => 'Torsten Becker',
        :street     => 'August-Bebel-Strasse 27', 
        :zipcode => '14482',
        :city       => 'Potsdam',
        :country    => 'Germany'
      }
      address = Address.create(attributes)

      assert address.valid?
      assert_equal attributes[:name], address.name
      assert_equal attributes[:street], address.street
      assert_equal attributes[:zipcode], address.zipcode
      assert_equal attributes[:city], address.locality
      assert_equal attributes[:country], address.country
    end
  end
end