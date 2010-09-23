class VideoUploader < AssetUploader

  def extension_white_list
    %w(swf)
  end

end
