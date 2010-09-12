require 'adva/engine'
require 'devise'

module Adva
  class User < ::Rails::Engine
    include Adva::Engine

    # TODO should probably happen in the client app
    # for more devise options see http://bit.ly/bwxrGg
    initializer 'adva-user.devise_setup' do
      Devise.setup do |config|
        require 'devise/orm/active_record'
        config.mailer_sender = 'please-change-me@config-initializers-devise.com'
        config.encryptor     = :bcrypt
      end

      Devise::FailureApp.class_eval do
        def redirect
          flash[:alert] = i18n_message unless flash[:notice]
          redirect_to send(:"new_#{scope}_session_path", :return_to => attempted_path)
        end
      end
    end

    initializer 'adva-user.register_asset_expansions' do
      ActionView::Helpers::AssetTagHelper.register_javascript_expansion(
        :session => %w()
      )

      ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion(
        :session => %w( adva-user/session
                        adva-core/admin/common
                        adva-core/admin/forms )
      )
    end
  end
end