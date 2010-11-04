class Layouts::Default::Menu < Adva::View::Menu
  include do
    def build
      ul(:id => :menu) do
        site.sections.each do |section|
          item(section.name, url_for(section))
        end
        render_items
      end
    end

    protected

      def active?(url, options)
        return false if url =~ %r(/admin/sites(/\d+)?$) && request.fullpath != url
        super
      end
  end
end
