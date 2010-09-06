class Account < ActiveRecord::Base
  has_many :sites, :dependent => :destroy
end