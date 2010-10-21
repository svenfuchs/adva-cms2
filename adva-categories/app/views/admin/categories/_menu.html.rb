class Admin::Categories::Menu < Adva::View::Menu::Admin::Actions
  include do
    def main
      item(:'.categories', index_path)
      item(resource.name, edit_path) if resource.try(:persisted?)
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

