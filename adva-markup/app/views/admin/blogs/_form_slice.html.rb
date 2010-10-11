require_dependency 'admin/blogs/_form.html'

Admin::Blogs::Form.class_eval do
  include do
    def fields
      super
      fieldset do
        column do
          form.input :default_filter, :as => :select, :collection => Adva::Markup.options
        end
      end
    end
  end
end
