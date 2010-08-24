require 'adva/image_uploader'

module Adva
  class Image < Asset

    set_table_name 'assets'

    mount_uploader :file, Adva::ImageUploader

    delegate :thumb, :small, :to => :file
  end
end