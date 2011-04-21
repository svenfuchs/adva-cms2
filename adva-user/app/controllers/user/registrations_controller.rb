class User::RegistrationsController < Devise::RegistrationsController
  layout 'user'

  def after_inactive_sign_up_path_for(resource)
    params[:return_to] || '/'
  end
end
