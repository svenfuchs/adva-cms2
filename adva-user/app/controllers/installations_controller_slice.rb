require 'installations_controller'

InstallationsController.class_eval do
  before_filter :set_admin_params, :only => :create

  def set_admin_params
    params[:account][:users_attributes] ||= [{ :email => 'admin@admin.org', :password => 'admin' }]
  end
end