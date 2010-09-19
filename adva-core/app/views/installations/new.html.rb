class Installations::New < Adva::View::Form
  include do
    def form_tag
      h2 :'.title'
      p :'.welcome'
      super
    end

    def form_arguments
      [resource, { :url => installations_path }]
    end

    def fields
      form.label :name
      form.text_field :name

      form.simple_fields_for(:sections) do |s|
        s.input :name, :label => t(:'.section_name')

        s.label :type
        section_types_option_values.each do |name, value|
          s.radio_button :type, value
          s.label :"type_#{value.underscore}", name, :class => :inline
        end
      end
    end

    # f.field_set :admin_account do
    #   fields_for @user do |user|
    #     column do
    #       user.text_field :email, :label => true, :tabindex => 3
    #     end
    #     column do
    #       user.password_field :password, :label => true, :tabindex => 4
    #     end
    #   end
    # end
  end
end