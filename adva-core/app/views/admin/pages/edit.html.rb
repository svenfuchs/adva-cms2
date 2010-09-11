class Admin::Pages::Edit < Minimal::Template
  def to_html
    h2 :'.title'
    simple_form_for(resources) do |f|
      hidden_field_tag :return_to, request.url
      f.hidden_field :type

      fieldset do
        column do
          f.input :title
        end
        column do
          f.input :slug
        end
      end

      buttons do
        f.button :submit
      end
    end
  end
end