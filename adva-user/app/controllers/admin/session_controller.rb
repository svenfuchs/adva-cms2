class Admin::SessionController < Devise::SessionsController
  layout 'login'

  def after_sign_in_path_for(resource)
    '/' # TODO
  end
end