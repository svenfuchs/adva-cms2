require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

require 'adva/address'
require 'address'
require 'itemized'
require 'cart'

module AdvaCart
  class CartTest < Test::Unit::TestCase
    test "accepts nested attributes for addresses" do
      cart = Cart.create!(
        :shipping_address_attributes => { :name => 'shipping name' }, 
        :billing_address_attributes  => { :name => 'billing name' }
      )

      assert !cart.shipping_address.new_record?
      assert !cart.billing_address.new_record?

      assert_equal 'shipping name', cart.shipping_address.name # TODO does this actually test anything?
      assert_equal 'billing name', cart.billing_address.name
    end
  end
end