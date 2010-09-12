class Passwords::New < Minimal::Template
  def to_html
    h2 :'.title'

    simple_form_for(resource, :as => resource_name, :url => password_path(resource_name)) do |f|
      devise_error_messages!
      
      f.input :email

      buttons do
        f.submit t(:'.submit')
        render :partial => 'session/links'
      end
    end
  end
end