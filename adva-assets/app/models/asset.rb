require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'asset_uploader'

class Asset < ActiveRecord::Base
  mount_uploader :file, AssetUploader

  belongs_to :site

  delegate :path, :filename, :extname, :basename, :current_path,
           :default_url, :base_url, :store_dir, :base_dir, :to => :file

  validates :file, :presence => true
  validates :site_id, :presence => true
end