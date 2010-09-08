class Admin::Pages::Menu < Adva::Views::Menu::Admin::Actions
  def left
    if resource.try(:persisted?)
      label("#{resource.title}:")
      item(:'.content', url_for(resources.unshift(:edit)))
      item(:'.edit', url_for(resources.unshift(:edit)))
    end
  end
  
  def right
    if resource.try(:persisted?)
      item(:'.view', public_url_for(resources))
      item(:'.delete', url_for(resources), :method => :delete)
    end
  end
end