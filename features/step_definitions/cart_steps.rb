Then /^the current user's cart should contain the following items:$/ do |table|
  assert cart = current_cart, "there should be a cart"
  table.hashes.each do |attributes|
    product = Product.where(:name => attributes['product']).first
    assert cart.items.where(:product_id => product.id, :quantity => attributes['quantity']).any?
  end
end

Then /^the cart should contain the following items:$/ do |table|
  table.hashes.each do |attributes|
    assert_select '.item' do
      assert_select 'td', attributes['product']
      assert_select 'td', attributes['quantity']
    end
  end
end

Then /^I press "([^"]*)" for the item "([^"]*)"$/ do |text, name|
  product = Product.where(:name => name).first
  item    = current_cart.items.where(:product_id => product.id).first
  within("#item_#{item.id}") { click_button(text) }
end
