require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'asset_uploader'

class Asset < ActiveRecord::Base
  self.abstract_class = true

  mount_uploader :file, AssetUploader

  # belongs_to :attachable, :polymorphic => true

  has_many_polymorphs :assetables, :through => :asset_assignments, :from => Adva::Registry.get(:assetable_types)

  belongs_to :site

  delegate :path, :filename, :extname, :basename, :current_path,
           :default_url, :base_url, :store_dir, :base_dir, :to => :file

  validates :file, :presence => true
  validates :title, :presence => true
  validates :site_id, :presence => true
end