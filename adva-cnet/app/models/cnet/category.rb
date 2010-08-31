module Cnet
  class Category < ActiveRecord::Base
    set_table_name 'cnet_categories'

    translates :name, :table_name => 'cnet_category_translations'
  end
end

