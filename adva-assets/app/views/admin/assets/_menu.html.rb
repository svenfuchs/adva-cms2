class Admin::Assets::Menu < Adva::Views::Menu::Admin::Actions
  def main
    label("#{resource.title}:")
    item(:'.show', admin_site_assets_path(site))
  end

  def right
    if persisted?
      item(:'.new', new_admin_site_asset_path(site, resource))
      item(:'.edit', edit_admin_site_asset_path(site, resource))
      item(:'.delete', admin_site_asset_path(site, resource), :method => :delete)
    end
  end

  protected

    # def active?(url, options)
    #   return false if url =~ %r(/admin/sites/\d+/#{types}/\d+$) && request.path != url
    #   super
    # end
end