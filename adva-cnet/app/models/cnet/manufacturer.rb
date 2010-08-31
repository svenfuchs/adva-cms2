module Cnet
  class Manufacturer < ActiveRecord::Base
    set_table_name 'cnet_manufacturers'

    translates :name, :table_name => 'cnet_manufacturer_translations'
  end
end