class Admin::Blogs::Menu < Adva::View::Menu::Admin::Actions
  include do
    def main
      if persisted?
        label("#{resource.title}:")
        item(:'.show', show_path)
        item(:'.edit', edit_path)
      else
        item(:'.sections', index_path)
      end
    end

    def right
      if persisted?
        item(:'.new_item', children_new_path(:posts))
        item(:'.delete', resource_path, :method => :delete)
      else
        item(:'.new', new_path)
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
end