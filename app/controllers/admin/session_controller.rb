class Admin::SessionController < Devise::SessionsController
  layout 'admin'
  
  def new
    super
  end
end