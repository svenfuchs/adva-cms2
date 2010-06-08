class Admin::BaseController < ActionController::Base
  layout 'admin'
  
  def self.responder
    Adva::Responder
  end
  
  def current_user
  end
  helper_method :current_user
end