class Cart < Itemized
  belongs_to :shipping_address, :class_name => 'Address'
  belongs_to :billing_address,  :class_name => 'Address'
  
  accepts_nested_attributes_for :shipping_address, :billing_address
end