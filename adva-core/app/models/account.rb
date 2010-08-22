class Account < ActiveRecord::Base
  has_many :sites, :dependent => :destroy
  has_many :users
end