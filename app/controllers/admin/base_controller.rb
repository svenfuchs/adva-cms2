class Admin::BaseController < ActionController::Base
  helper Admin::BaseHelper
  
  def self.responder
    Admin::Responder
  end
end