# TODO i18n

class User::Links < Minimal::Template
  def to_html
    ul :class => :links do
      li { sign_in_link }             if sign_in?
      li { sign_up_link }             if sign_up?
      li { forgot_password_link }     if forgot_password?
      li { resend_confirmation_link } if resend_confirmation?
      li { resend_unlock_link }       if resend_unlock?
    end
  end

  def sign_in?
    controller_name != 'session'
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

  def sign_in_link
    capture { link_to("Sign in", new_session_path(resource_name)) }
  end

  def sign_up_link
    capture { link_to("Sign up", new_registration_path(resource_name)) }
  end

  def forgot_password_link
    capture { link_to("Forgot your password?", new_password_path(resource_name)) }
  end

  def resend_confirmation_link
    capture { link_to("Resend confirmation email", new_confirmation_path(resource_name)) }
  end

  def resend_unlock_link
    capture { link_to("Resend unlock email", new_unlock_path(resource_name)) }
  end
end