class Account < ActiveRecord::Base
  has_many :sites
  has_many :users
end