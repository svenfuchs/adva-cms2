class CartConfirmationController < BaseController
  # before_filter :set_cart_addresses, :only => [:new]
  #
  # defaults :resource_class => Address, :collection_name => 'address', :instance_name => 'address', :singleton => true
  
  def create
    # current_cart.update_attributes(params[:addresses])
    # respond_with current_cart, :addresses
  end

  protected

    def resource
      current_cart
    end

    def build_resource
      current_cart
    end

    def begin_of_association_chain
      current_cart
    end

  #   def set_cart_addresses
  #     current_cart.build_shipping_address
  #     current_cart.build_billing_address
  #   end
end