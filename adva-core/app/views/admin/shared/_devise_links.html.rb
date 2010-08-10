module Admin
  module Shared
    class DeviseLinks < Minimal::Template
      def to_html
        # TODO i18n
        link_to "Sign in", new_session_path(resource_name)                        if sign_in?
        link_to "Sign up", new_registration_path(resource_name)                   if sign_up?
        link_to "Forgot your password?", new_password_path(resource_name)         if forgot_password?
        link_to "Resend confirmation email", new_confirmation_path(resource_name) if resend_confirmation?
        link_to "Resend unlock email", new_unlock_path(resource_name)             if resend_unlock?
      end
      
      def sign_in?
        controller_name != 'sessions'
      end
      
      def sign_up?
        devise_mapping.registerable? && controller_name != 'registrations'
      end
      
      def forgot_password?
        devise_mapping.recoverable? && controller_name != 'passwords'
      end
      
      def resend_confirmation?
        devise_mapping.confirmable? && controller_name != 'confirmations'
      end
      
      def resend_unlock?
        devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks'
      end
    end
  end
end
