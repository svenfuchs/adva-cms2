class User::SessionsController < Devise::SessionsController
  layout 'user'

  def after_sign_in_path_for(resource)
    params[:return_to] || '/'
  end
end
