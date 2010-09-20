class Admin::Assets::Menu < Adva::View::Menu::Admin::Actions
  def main
    label(resource.title)
    item(:'.show', index_path)
  end

  def right
    if persisted?
      item(:'.new', new_path)
      item(:'.edit', edit_path)
      item(:'.delete', resource_path, :method => :delete, :confirm => t(:'.confirm_delete', :model_name => resource.class.model_name.human))
    end
  end

  protected

    # def active?(url, options)
    #   return false if url =~ %r(/admin/sites/\d+/#{types}/\d+$) && request.path != url
    #   super
    # end
end