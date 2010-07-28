class CartItemsController < BaseController
  defaults :resource_class => Item, :collection_name => 'items', :instance_name => 'item'

  protected

    def begin_of_association_chain
      current_cart
    end
end