class Admin::BaseController < ActionController::Base
  helper Admin::BaseHelper
  layout 'admin'
  
  # def self.responder
  #   Admin::Responder
  # end
  
  def current_user
  end
  helper_method :current_user
end