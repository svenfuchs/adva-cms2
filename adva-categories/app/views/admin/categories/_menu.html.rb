class Admin::Categories::Menu < Adva::View::Menu::Admin::Actions
  include do
    def main
      label("#{parent_resource.class.name}:")
      item(:'admin.categories.menu.categories', index_path)
      item(:'admin.categories.menu.edit', edit_parent_path)
    end

    def right
      if resource.try(:persisted?)
        item(:'.destroy', resource_path, :method => :delete, :confirm => t(:'.confirm_destroy', :model_name => resource.class.model_name.human))
      else
        item(:'.new', new_path)
        item(:'.reorder', show_parent_path, :'data-resource_type' => parent_resource.class.name.underscore, :'data-sortable_type' => 'categories')
      end
    end
  end
end

