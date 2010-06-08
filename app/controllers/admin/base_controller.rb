class Admin::BaseController < ActionController::Base
  
  respond_to :html
  layout 'admin'
  
  def self.responder
    Adva::Responder
  end
  
  def current_user
    Struct.new(:name, :roles).new('Ingo', ['admin'])
  end
  helper_method :current_user
end