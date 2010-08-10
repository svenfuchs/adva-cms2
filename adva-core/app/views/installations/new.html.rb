class Installations::New < Minimal::Template
  def to_html
    form_for(site, :url => installations_path) do |f|
      hidden_field_tag :return_to, '/'

      f.label :name
      f.text_field :name

      f.fields_for(:sections) do |s|
        s.label :type
        s.select :type, section_types_for_select

        s.label :title, :'.title', :class => 'block'
        s.text_field :title
      end

      f.submit 'Create'
    end
  end
end