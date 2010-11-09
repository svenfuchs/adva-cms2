# this should rather be a code slice, shouldn't it? but slices don't support files
# that aren't loadable through require_dependency

require 'adva/view/form'

Adva::View::Form.class_eval do
  def categories_tab(categories)
    tab :categories do
      fieldset do
        form.has_many_through_collection_check_boxes(:categorizations, categories, :name)
      end
    end if categories.present?
  end
end
