class Admin::Pages::Edit < Minimal::Template
  def to_html
    h2 :'.title'
    simple_form_for(resources) do |f|
      hidden_field_tag :return_to, request.url
      f.input :title
      f.button :submit
    end
  end
end