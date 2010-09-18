class Installations::New < Minimal::Template
  def to_html
    h2 :'.title'
    p :'.welcome'

    form_for(site, :url => installations_path) do |f|
      f.label :name
      f.text_field :name

      f.fields_for(:sections) do |s|
        s.label :title, t(:'.section_title')
        s.text_field :title

        s.label :type
        section_types_option_values.each do |name, value|
          s.radio_button :type, value
          s.label "type_#{value.underscore}", name, :class => :inline
        end
      end

      button_group do
        f.submit 'Create'
      end
    end
  end
end