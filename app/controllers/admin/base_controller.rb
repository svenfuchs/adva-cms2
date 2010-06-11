class Admin::BaseController < ActionController::Base
  
  before_filter :authenticate_user!
  
  respond_to :html
  layout 'admin'
  
  def self.responder
    Adva::Responder
  end
  
end