require 'admin/base_controller'

Admin::BaseController.class_eval do
  before_filter :authenticate_user!
end
