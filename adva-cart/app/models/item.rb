class Item < ActiveRecord::Base
  belongs_to :itemized
  belongs_to :product

  def locked?
    read_attribute(:price).present?
  end

  def price
    locked? ? read_attribute(:price) : product.price
  end

  def vat
    locked? ? read_attribute(:vat) : product.vat
  end

  def total_price
    quantity * price
  end
end