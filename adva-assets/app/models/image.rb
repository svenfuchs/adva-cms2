require 'image_uploader'

class Image < Asset
  set_table_name 'assets'

  mount_uploader :file, ImageUploader

  delegate :thumb, :small, :to => :file
end