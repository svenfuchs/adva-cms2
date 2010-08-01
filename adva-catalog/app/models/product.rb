class Product < ActiveRecord::Base
  belongs_to :account

  has_slug :scope => :account_id

  def price
    read_attribute(:price) / 100
  end

  def vat
    read_attribute(:vat) / 100
  end

  def to_param(name)
    name == :slug ? slug : super()
  end
end