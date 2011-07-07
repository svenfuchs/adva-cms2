Adva.slice 'admin/base_controller#adva-user' do
  before_filter :authenticate_user!
  require 'adva_user/authorization'
  include AdvaUser::Authorization
end
