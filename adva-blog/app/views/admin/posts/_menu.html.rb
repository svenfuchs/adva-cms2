class Admin::Posts::Menu < Adva::Views::Menu::Admin::Actions
  def left
    label("#{resource.section.title}:")
    item(:'.show', admin_site_blog_path(site, resource.section))
  end
  
  def right
    if persisted?
      item(:'.new', new_admin_site_blog_post_path(site, resource.section))
      item(:'.view', public_url_for([resource.section, resource]))
      item(:'.edit', edit_admin_site_blog_post_path(site, resource.section, resource))
      item(:'.delete', admin_site_blog_post_path(site, resource.section, resource), :method => :delete)
    end
  end
end