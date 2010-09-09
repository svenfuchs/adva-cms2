class Admin::Pages::Menu < Adva::Views::Menu::Admin::Actions
  def main
    if resource.try(:persisted?)
      label("#{resource.title}:")
      item(:'.show', url_for(resources))
      item(:'.edit', url_for(resources.unshift(:edit)))
    end
  end
  
  def right
    if resource.try(:persisted?)
      item(:'.view', public_url_for(resources))
      item(:'.delete', url_for(resources), :method => :delete)
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