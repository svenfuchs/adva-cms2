class User::Form < Adva::View::Form
  include do
    def fields
      devise_error_messages!
      super
    end

    def button_group
      super
      links
    end

    def buttons
      form.submit t(:'.submit')
    end

    def links
      ul :class => 'links user' do
        li { sign_in_link }             if sign_in?
        li { sign_up_link }             if sign_up?
        li { forgot_password_link }     if forgot_password?
        li { resend_confirmation_link } if resend_confirmation?
        li { resend_unlock_link }       if resend_unlock?
      end
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

    def sign_in_link
      capture { link_to(:'user.links.sign_in', new_session_path(resource_name), :class => :sign_in) }
    end

    def sign_up_link(options={}, html_options={})
      capture { link_to(:'user.links.sign_up', new_registration_path(resource_name, options), { :class => :sign_up }.merge(html_options)) }
    end

    def forgot_password_link
      capture { link_to(:'user.links.forgot_password', new_password_path(resource_name), :class => :forgot_password) }
    end

    def resend_confirmation_link
      capture { link_to(:'user.links.resend_confirmation', new_confirmation_path(resource_name), :class => :resend_confirmation) }
    end

    def resend_unlock_link
      capture { link_to(:'user.links.resend_unlock', new_unlock_path(resource_name), :class => :resend_unlock) }
    end
  end
end
