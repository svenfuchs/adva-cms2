class Admin::Pages::Show < Adva::View::Form
  def to_html
    h2 :'.title'

    simple_form_for(resources) do |f|
      f.simple_fields_for(:article) do |a|
        a.input :body
      end

      buttons do
        f.button :submit
      end
    end
  end

  def sidebar
    tab :options do
      simple_fields_for(resource) do |f|
        f.input :title
        f.input :slug
      end
    end
  end
end