class Admin::Posts::Menu < Adva::View::Menu::Admin::Actions
  include do
    def main
      label(resource.section.name)
      item(:'.show', parent_show_path)
      item(:'.edit_parent', parent_edit_path)
    end

    def right
      item(:'.new', new_path)
      if persisted?
        item(:'.view', public_url)
        item(:'.edit', edit_path)
        item(:'.destroy', resource_path, :method => :delete, :confirm => t(:'.confirm_destroy', :model_name => resource.class.model_name.human))
      end
    end
  end
end
