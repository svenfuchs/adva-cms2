class Admin::Blogs::Form < Minimal::Template
  def to_html
    simple_form_for(resources) do |f|
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