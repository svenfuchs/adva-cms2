class User::RegistrationsController < Devise::RegistrationsController
  layout 'user'

  protected

    def after_inactive_sign_up_path_for(resource)
      if resource.is_a?(User)
        params[:return_to] || new_user_session_path
      else
        raise "unknown resource: #{resource}"
      end
    end
end
