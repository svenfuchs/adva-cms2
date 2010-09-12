class SessionController < Devise::SessionsController
  layout 'session'

  def after_sign_in_path_for(resource)
    '/' # TODO
  end
end