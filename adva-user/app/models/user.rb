require 'devise'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, # :confirmable,
    :recoverable, :validatable, :trackable
  
  serialize :roles, Array
  
  def roles
    read_attribute(:roles) || []
  end
end