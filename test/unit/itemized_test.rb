require File.expand_path('../../test_helper', __FILE__)
require 'itemized'
require 'item'
require 'order'
require 'cart'
require 'product'

class ItemizedTest < Test::Unit::TestCase
  test "Order.all returns orders but not carts" do
    order = Order.create!
    cart  = Cart.create!

    assert Order.all.map(&:id).include?(order.id)
    assert !Order.all.map(&:id).include?(cart.id)
  end

  test "Cart.all returns carts but not orders" do
    order = Order.create!
    cart  = Cart.create!
    
    assert Cart.all.map(&:id).include?(cart.id)
    assert !Cart.all.map(&:id).include?(order.id)
  end

  test "item.itemized returns a cart or order" do
    order = Order.create! :items => [Item.create!]
    cart  = Cart.create!  :items => [Item.create!]
    
    assert_equal order, order.items.first.itemized
    assert_equal cart,  cart.items.first.itemized
  end
  
  test "item.price reflects the product price unless locked?" do
    product = Product.create! :name => 'Apple pie', :price => 200
    item = Item.new :product => product

    assert !item.locked?
    assert_equal 2.0, item.price
  end
  
  test "item.price reflects the item's price if locked?" do
    product = Product.create! :name => 'Apple pie', :price => 200
    item = Item.new :product => product, :price => 300

    assert item.locked?
    assert_equal 3.0, item.price
  end
end
