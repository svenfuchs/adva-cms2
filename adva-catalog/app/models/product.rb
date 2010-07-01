require 'content'

class Product < Content
  belongs_to :account
end