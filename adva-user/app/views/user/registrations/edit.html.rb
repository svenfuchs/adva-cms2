class User::Registrations::Edit < Minimal::Template
  def to_html
    h2 :'.title'

    simple_form_for(resource, :as => resource_name, :url => registration_path(resource_name), :html => { :method => :put }) do |f|
      devise_error_messages!
      
      f.input :email
      f.input :password
      f.input :password_confirmation

      f.input :current_password
      p :'.current_password_required'

      buttons do
        f.submit t(:'.submit')
        render :partial => 'user/links'
      end
    end
  end
end