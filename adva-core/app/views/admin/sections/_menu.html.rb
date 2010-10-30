# Base menu for sections. Also used on admin/sections/new.
class Admin::Sections::Menu < Adva::View::Menu::Admin::Actions
  include do
    def main
      if collection?
        index
      else
        resource_label
        show
        edit
      end
    end

    def right
      if collection?
        new
        reorder
      elsif edit?
        destroy
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
