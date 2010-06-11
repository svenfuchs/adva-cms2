class User < ActiveRecord::Base
  devise :database_authenticatable #, :confirmable, :recoverable, :rememberable, :trackable, :validatable
end