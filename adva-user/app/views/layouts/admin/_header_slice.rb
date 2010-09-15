require_dependency 'layouts/admin'
require_dependency 'layouts/admin/_header'

module Layouts::Admin::Header::User
  def right
    login_status
    super
  end

  def login_status
    link_to t('.sign_out', :user => current_user.email), destroy_user_session_path
    self << '&middot;'.html_safe
  end

  Layouts::Admin::Header.send(:include, self)
end