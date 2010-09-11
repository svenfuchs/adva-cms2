class Admin::Sites::New < Minimal::Template
  def to_html
    h2 :'.title'

    simple_form_for(resources) do |f|
      fieldset do
        column do
          f.input :name
          f.input :host
        end

        column do
          f.input :title
        end
      end

      fieldset do
        f.simple_fields_for(:sections) do |s|
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

      buttons do
        f.button :submit
      end
    end
  end
end