class Admin::Pages::Show < Minimal::Template
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
end