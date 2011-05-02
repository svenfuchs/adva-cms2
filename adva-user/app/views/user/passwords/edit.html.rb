class User::Passwords::Edit < User::Form
  include do
    def to_html
      h2 :'.title'
      super
    end

    def fields
      super
      form.hidden_field :reset_password_token
      form.input :password
      form.input :password_confirmation
    end

    def form_arguments
      [resource, { :as => resource_name, :url => password_path(resource_name), :html => { :method => :put } }]
    end
  end
end
