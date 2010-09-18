class Admin::Sites::New < Adva::View::Form
  def to_html
    h2 :'.title'
    super
  end

  def fields
    fieldset do
      column do
        form.input :name
        form.input :host
      end

      column do
        form.input :title
      end
    end

    fieldset do
      form.simple_fields_for(:sections) do |s|
        column do
          s.input :title, :label => "Section title"
        end

        column do
          s.label :type
          div :class => :radio_group do
            section_types_option_values.each do |name, value|
              s.radio_button :type, value
              s.label "type_#{value.underscore}", name, :class => :inline
            end
          end
        end
      end
    end
  end
end