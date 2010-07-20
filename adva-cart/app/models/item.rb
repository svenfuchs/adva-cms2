class Item < ActiveRecord::Base
  belongs_to :itemized
  belongs_to :product
  
  def locked?
    read_attribute(:price).present?
  end
  
  def price
    locked? ? read_attribute(:price) : product.price
  end
end