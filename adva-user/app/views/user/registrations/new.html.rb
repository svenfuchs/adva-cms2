class User::Registrations::New < Minimal::Template
  def to_html
    h2 :'.title'

    simple_form_for(resource, :as => resource_name, :url => registration_path(resource_name)) do |f|
      devise_error_messages!
      
      f.input :email
      f.input :password
      f.input :password_confirmation

      buttons do
        f.button :submit
        render :partial => 'user/links'
      end
    end
  end
end