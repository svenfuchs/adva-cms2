require 'carrierwave'

class AssetUploader < CarrierWave::Uploader::Base

  storage :file
  permissions 0666

  store_dir '/tmp/uploads'
  cache_dir '/tmp/uploads/tmp'

  # Override the directory where uploaded files will be stored
  def store_dir
    if Rails.env.test?
      "/tmp/sites/site-#{model.site_id}/assets/file/#{model.id}"
    else
      "sites/site-#{model.site_id}/assets/file/#{model.id}"
    end
  end

end
