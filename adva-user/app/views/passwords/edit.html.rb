class Passwords::Edit < Minimal::Template
  def to_html
    h2 :'.title'

    simple_form_for(resource, :as => resource_name, :url => password_path(resource_name), :html => { :method => :put }) do |f|
      devise_error_messages!
      
      f.hidden_field :reset_password_token
      f.input :password
      f.input :password_confirmation

      buttons do
        f.submit t(:'.submit')
        render :partial => 'session/links'
      end
    end
  end
end