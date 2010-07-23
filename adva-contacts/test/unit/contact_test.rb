require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'adva/contact'
require 'adva/address'

class ContactTest < Test::Unit::TestCase
  test "can create a valid contact" do
    attributes = {
      :full_name  => 'Torsten Becker',
      :street     => 'August-Bebel-Strasse 27', 
      :postalcode => '14482',
      :city       => 'Potsdam',
      :country    => 'Germany'
    }
    contact = Adva::Contact.create(attributes)

    assert contact.valid?
    assert_equal attributes[:full_name], contact.full_name
    assert_equal attributes[:street], contact.street
    assert_equal attributes[:postalcode], contact.postalcode
    assert_equal attributes[:city], contact.city
    assert_equal attributes[:country], contact.country
  end
end
