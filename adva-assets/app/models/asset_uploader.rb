require 'carrierwave'

class AssetUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file
  permissions 0600

  store_dir '/tmp/uploads'
  cache_dir '/tmp/uploads/tmp'

  # Override the directory where uploaded files will be stored
  def store_dir
    if Rails.env.test? and Rails.root.nil?
      "/tmp/sites/site-#{model.site_id}/assets/#{mounted_as}/#{model.id}"
    else
      "sites/site-#{model.site_id}/assets/#{mounted_as}/#{model.id}"
    end
  end

  process :resize_to_limit => [600, 600]

  version :thumb do
    process :resize_to_fill => [64, 64]
  end

  version :small do
    process :resize_to_fill => [200, 200]
  end

end
