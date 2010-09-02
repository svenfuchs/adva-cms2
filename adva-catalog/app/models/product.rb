require 'simple_slugs'
require 'asset_assignment'

class Product < ActiveRecord::Base
  belongs_to :account

  has_many :asset_assignments, :foreign_key => :obj_id, :dependent => :destroy
  has_many :assets, :through => :asset_assignments
  
  accepts_nested_attributes_for :assets
  
  has_slug :scope => :account_id

  def price
    read_attribute(:price).to_i / 100
  end

  def vat
    read_attribute(:vat).to_i / 100
  end

  def to_param(name)
    name == :slug ? slug : super()
  end

  def main_image
    self.asset_assignments.order('weight DESC').first.asset
  end

  def title
  end
  def file
  end
end