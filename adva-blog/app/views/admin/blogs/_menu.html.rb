class Admin::Blogs::Menu < Adva::Views::Menu::Admin::Actions
  def main
    if persisted?
      label("#{resource.title}:")
      item(:'.show', admin_site_blog_path(site, resource))
      item(:'.edit', edit_admin_site_blog_path(site, resource))
    end
  end

  def right
    if persisted?
      item(:'.new_item', new_admin_site_blog_post_path(site, resource))
      item(:'.delete', admin_site_blog_path(site, resource), :method => :delete)
    end
  end

  protected

    def active?(url, options)
      # hmmm ...
      types = Section.types.map { |type| type.underscore.pluralize }.join('|')
      return false if url =~ %r(/admin/sites/\d+/#{types}/\d+$) && request.path != url
      super
    end
end