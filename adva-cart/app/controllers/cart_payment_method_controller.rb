class CartPaymentMethodController < BaseController
  # before_filter :set_cart_addresses, :only => [:new]
  #
  # defaults :resource_class => Address, :collection_name => 'address', :instance_name => 'address', :singleton => true
  
  def update
    current_cart.update_attributes(params[:cart])
    respond_with current_cart, :payment_method
  end

  protected

    def resource
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