class Admin::SessionController < Devise::SessionsController
  layout 'login'
  
  def new
    super
  end
end