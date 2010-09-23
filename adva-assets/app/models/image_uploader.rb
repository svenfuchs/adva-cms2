module MiniMagick
  class MiniMagickError < Exception;
  end
end

class ImageUploader < AssetUploader

  include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process :resize_to_limit => [600, 600]

  version :thumb do
    process :resize_to_fill => [64, 64]
  end

  version :small do
    process :resize_to_fill => [200, 200]
  end

end
