class Admin::Categories::Form < Adva::View::Form
  include do
    def fields
      fieldset do
        form.input :name
      end
    end

    def sidebar
      tab :options do
        form.input :slug
      end
    end
  end
end


