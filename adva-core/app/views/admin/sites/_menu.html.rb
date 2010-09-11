class Admin::Sites::Menu < Adva::Views::Menu::Admin::Actions
  def right
    item(:'.new', new_path)
    if persisted?
      item(:'.new_item', children_new_path(:sections))
      item(:'.delete', resource_path, :method => :delete)
    end
  end
end