class Admin::Posts::Form < Adva::View::Form
  include do
    def fields
      fieldset do
        form.input :title
        form.input :body
      end
    end

    def sidebar
      if Adva.engine?(:categories) && blog.categories.present?
        # TODO extract to Adva::View::Form#categorizable_tab or something
        tab :categories do
          fieldset do
            form.has_many_through_collection_check_boxes(:categorizations, blog.categories, :name)
          end
        end
      end

      tab :options do
        form.input :slug
      end
    end
  end
end
