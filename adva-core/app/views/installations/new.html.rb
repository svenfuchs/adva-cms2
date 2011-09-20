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

      form.simple_fields_for :account do |account|
        account.simple_fields_for :users do |user|
          user.text_field :email, :label => true
          user.password_field :password, :label => true
        end
      end
    end
  end
end
