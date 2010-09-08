class Installations::New < Minimal::Template
  def to_html
    form_for(site, :url => installations_path) do |f|
      f.label :name, :class => 'block'
      f.text_field :name

      f.fields_for(:sections) do |s|
        s.label :type, :class => 'block'
        section_types_option_values.each do |name, value|
          s.radio_button :type, value
          s.label "type_#{value.underscore}", name
        end

        s.label :title, :class => 'block'
        s.text_field :title
      end

      f.submit 'Create'
    end
  end
end