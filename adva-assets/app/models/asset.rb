require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'asset_uploader'
require 'asset_assignment'

class Asset < ActiveRecord::Base

  self.abstract_class = true

  mount_uploader :file, AssetUploader

  has_many :asset_assignments, :order => 'position', :dependent => :destroy
  #has_many :objs, :through => :asset_assignments
  has_many :objs, :through => :asset_assignments, :source => :product

  belongs_to :site

  delegate :path, :filename, :extname, :basename, :current_path,
           :default_url, :base_url, :store_dir, :base_dir, :to => :file

  validates :file, :presence => true
  validates :title, :presence => true
  validates :site_id, :presence => true

  #todo in assigned classes: accepts_nested_attributes_for :assets, :allow_destroy => true

end