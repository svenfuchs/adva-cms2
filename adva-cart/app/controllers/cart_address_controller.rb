class CartAddressController < BaseController
  
  defaults :resource_class => Address, :collection_name => 'address', :instance_name => 'address', :singleton => true
  
  def begin_of_association_chain
    current_cart
  end
  
end