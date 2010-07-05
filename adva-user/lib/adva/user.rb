require 'adva-core'
require 'devise'

module Adva
  class User < ::Rails::Engine
    include Adva::Engine

    # TODO should probably happen in the client app
    initializer 'adva.user.devise_setup' do
      Devise.setup do |config|
        require 'devise/orm/active_record'
        # for more devise options see http://bit.ly/bwxrGg
        config.mailer_sender = "please-change-me@config-initializers-devise.com"
      end
    end

    initializer 'adva.user.add_users_to_account' do
      Account.has_many :users, :dependent => :destroy
    end
  end
end