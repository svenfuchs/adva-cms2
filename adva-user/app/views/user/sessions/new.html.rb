class User::Sessions::New < User::Form
  include do
    def to_html
      h2 :'.title'
      super
    end

    def fields
      super
      pass_return_to
      form.input :email
      form.input :password
      remember_me if devise_mapping.rememberable?
    end

    def form_arguments
      [resource, { :as => resource_name, :url => session_path(resource_name) }]
    end

    def remember_me
      div :class => :checkbox_group do
        form.check_box :remember_me
        form.label :remember_me, :class => :inline
      end
    end
  end
end
