class Admin::Sites::Edit < Minimal::Template
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

      buttons do
        f.button :submit
      end
    end
  end
end