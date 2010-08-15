class Admin::Sites::New < Minimal::Template
  def to_html
    h2 :'.title'
    form_for(resources) do |f|
      f.label :name
      f.text_field :name

      f.label :title
      f.text_field :title

      f.label :host
      f.text_field :host

      f.fields_for(:sections) do |s|
        s.label :type
        s.select :type, section_types_for_select

        s.label :title, "Section title"
        s.text_field :title
      end

      f.submit 'Create'
    end
  end
end