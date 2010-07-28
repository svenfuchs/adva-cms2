class Cart < Itemized
  belongs_to :shipping_address, :class_name => 'Address'
  belongs_to :billing_address,  :class_name => 'Address'

  accepts_nested_attributes_for :shipping_address, :billing_address

  def items_attributes=(attributes)
    attributes = attributes.values if attributes.is_a?(Hash)
    attributes.each do |attrs|
      if item = items.by_product_id(attrs[:product_id]).first
        item.update_attributes(:quantity => attrs[:quantity].to_i + item.quantity)
      else
        items.build(attrs)
      end
    end
  end

  def total_price
    items.map(&:total_price).inject(&:+)
  end

  def total_vat
    items.map(&:total_vat).inject(&:+)
  end
end