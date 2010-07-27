class Product < ActiveRecord::Base
  belongs_to :account

  def price
    read_attribute(:price) / 100
  end
end