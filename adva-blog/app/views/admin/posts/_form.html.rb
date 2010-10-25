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

      if Adva.engine?(:categories)
        tab :categories do
          # h4 :'categories'
          form.label :categories
          form.has_many_through_collection_check_boxes(:categorizations, blog.categories, :name)
        end
      end
    end
  end
end
