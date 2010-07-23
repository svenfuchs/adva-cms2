class CartAddressController < BaseController

  defaults :resource_class => Address, :collection_name => 'address', :instance_name => 'address', :singleton => true

  def begin_of_association_chain
    current_cart
  end

end

# Cart
#   belongs_to :shipping_address
#   belongs_to :billing_address
#   has_many :addresses, :as => :addressable
#
# Address
#
# cart[:addresses_attributes] = [
#   { :kind => 'shipping', :street => ... },
#   { :kind => 'billing', :street => ... }
# ]
#
# cart[:shipping_address_attributes] = {
#   :id => ...
#   :street => ...
# }
# cart[:billing_address_attributes] = {
#   :street => ...
# }
#
# form_for cart do |f|
#   f.fields_for :shipping_address do |a|
#     f.input :street
#   end
# end
#
# POST cart/addresses
# PUT  cart/addresses