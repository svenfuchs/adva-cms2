class User::Passwords::New < User::Form
  include do
    def to_html
      h2 :'.title'
      super
    end

    def fields
      form.input :email
    end

    def form_arguments
      [resource, { :as => resource_name, :url => password_path(resource_name) }]
    end
  end
end