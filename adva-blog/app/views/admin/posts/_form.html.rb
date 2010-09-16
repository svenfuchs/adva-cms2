class Admin::Posts::Form < Adva::View::Form
  def to_html
    simple_form_for(resources) do |f|
      fieldset do
        f.input :title
        f.input :body
      end

      buttons do
        f.button :submit
      end
    end
  end
  
  def sidebar
    tab :options do
      simple_fields_for(resource) do |f|
        f.input :slug
      end
    end
  end
end