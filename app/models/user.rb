class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable #, :validatable, :confirmable, :recoverable , :trackable
end