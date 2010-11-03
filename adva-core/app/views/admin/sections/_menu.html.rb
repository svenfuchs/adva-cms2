# Base menu for sections. Also used on admin/sections/new.
class Admin::Sections::Menu < Adva::View::Menu::Admin::Actions
  include do
    def main
      if collection?
        index
      else
        resource_label
        show
        edit unless page?
      end
    end

    def right
      new if collection?
      destroy if edit?
      reorder if index? # TODO should only happen if we actually have more than 1 category
    end

    protected

      def page?
        resource.is_a?(Page)
      end

      def edit
        item(:'.edit_section', edit_path)
      end

      def active?(url, options)
        # hmmm ...
        types = Section.types.map { |type| type.underscore.pluralize }.join('|')
        return false if url =~ %r(/admin/sites/\d+/#{types}/\d+$) && request.path != url
        super
      end
  end
end
