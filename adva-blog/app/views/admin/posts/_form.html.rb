class Admin::Posts::Form < Adva::View::Form
  include do
    def fields
      fieldset do
        form.input :title
        form.input :body
      end
    end

    def sidebar
      tab :options do
        form.input :slug
      end
    end
  end
end
