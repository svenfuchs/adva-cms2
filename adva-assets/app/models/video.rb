require 'video_uploader'

class Video < Asset
  set_table_name 'assets'

  mount_uploader :file, VideoUploader

  delegate :thumb, :small, :to => :file
end