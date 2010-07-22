class Itemized < ActiveRecord::Base
  has_many    :items
  belongs_to  :address
end