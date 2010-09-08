class Admin::Sites::Menu < Adva::Views::Menu::Admin::Actions
  def right
    item(:'.new', new_admin_site_path)
    item(:'.delete', url_for(resources), :method => :delete) if persisted?
  end
end