require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'adva/asset_uploader'

module Adva
  class Asset < ActiveRecord::Base
    include Adva

    self.abstract_class = true    

    mount_uploader :file, Adva::AssetUploader

    belongs_to :site

    delegate :path, :filename, :extname, :basename, :current_path,
             :default_url, :base_url, :store_dir, :base_dir, :to => :file

    validates :file, :presence => true
    validates :title, :presence => true
    validates :site_id, :presence => true
    
    #todo in assigned classes: accepts_nested_attributes_for :assets, :allow_destroy => true

  end
end