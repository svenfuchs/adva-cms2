require File.expand_path('../../test_helper', __FILE__)

require 'adva/address'
require 'address'
require 'itemized'
require 'item'
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

    test "accepts nested attributes for items" do
      cart = Cart.create!(
        :items_attributes => [{ :product_id => 1, :quantity => 2 }]
      )

      item = cart.items.first.reload
      assert !item.new_record?

      assert_equal 1, item.product_id # TODO does this actually test anything?
      assert_equal 2, item.quantity

    end
  end
end