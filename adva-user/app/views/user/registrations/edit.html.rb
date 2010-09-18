class User::Registrations::Edit < User::Form
  def to_html
    h2 :'.title'
    super
  end

  def fields
    form.input :email
    form.input :password
    form.input :password_confirmation
  end

  def form_arguments
    [resource, { :as => resource_name, :url => registration_path(resource_name), :html => { :method => :put } }]
  end
end