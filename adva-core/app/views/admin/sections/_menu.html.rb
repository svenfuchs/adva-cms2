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
      reorder if index? && collection.size > 1
    end

    protected

      def index
        item(:".sections", index_parent_path(:sections))
      end

      def reorder
        super( :'data-resource_type' => 'site', :'data-sortable_type' => 'sections')
      end

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
