class Admin::Sites::Menu < Adva::Views::Menu::Admin::Actions
  def right
    item(:'.new', new_admin_site_path)
    if persisted?
      item(:'.new_item', new_admin_site_section_path(site))
      item(:'.delete', url_for(resources), :method => :delete)
    end
  end
end