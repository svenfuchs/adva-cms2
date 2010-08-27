class AssetUploader < CarrierWave::Uploader::Base

  # Choose what kind of storage to use for this uploader
  storage :file # :s3
  # set permission
  permissions 0600

  cattr_accessor :root_dir
  @@root_dir = File.expand_path('../../../../public', __FILE__)

  # Override the directory where uploaded files will be stored
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{base_dir}/#{mounted_as}/#{model.id}"
  end

  # TODO is this really necessary?
  def url
    "#{base_url}/#{[version_name, filename].compact.join('_')}" if base_url
  end

  # Provide a default URL as a default if there hasn't been a file uploaded
  def default_url
    "#{base_url}/#{[version_name, "default.png"].compact.join('_')}" if base_url
  end

  def base_url
    "/sites/site-#{model.site_id}/assets" if model.site_id.present?
  end

  def base_dir
    "#{root_dir}/sites/site-#{model.site_id}/assets" if model.site_id.present?
  end
    
  def basename
    filename.gsub(/\.#{extname}$/, "")
  end

  def extname
    File.extname(filename).gsub(/^\.+/, '')
  end

  # Add a white list of extensions which are allowed to be uploaded,
  # for images you might use something like this:
  #def extension_white_list
  #  %w(jpg jpeg gif png)
  #end
  
  # Process files as they are uploaded.
  #     process :scale => [200, 300]
  #
  #     def scale(width, height)
  #       # do something
  #     end

  # Create different versions of your uploaded files
  #     version :thumb do
  #       process :scale => [50, 50]
  #     end

  # Override the filename of the uploaded files
  #     def filename
  #       "something.jpg" if original_filename
  #     end

#  include CarrierWave::RMagick
#
#  process :resize_to_fill => [200, 200]
#  process :convert => 'png'
#
#  def filename
#    super + '.png'
#  end

#  version :animal do
#    version :human
#    version :monkey
#    version :llama
#  end

end
