class User::Confirmations::New < User::Form
  include do
    def to_html
      h2 :'.title'
      super
    end

    def fields
      super
      form.input :email
    end

    def form_arguments
      [resource, { :as => resource_name, :url => confirmation_path(resource_name) }]
    end
  end
end
