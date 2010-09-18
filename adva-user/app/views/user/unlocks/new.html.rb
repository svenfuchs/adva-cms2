class User::Unlocks::New < User::Form
  include do
    def to_html
      h2 :'.title'
      super
    end

    def fields
      form.input :email
    end

    def form_arguments
      [resource, { :as => resource_name, :url => unlock_path(resource_name) }]
    end
  end
end