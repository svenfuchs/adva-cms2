class Layouts::Admin::Top < Adva::View::Menu::Admin
  id :top

  include do
    def main
      if site.try(:persisted?)
        sites
        sections unless site.new_record?
        item(:'.assets', url_for([:admin, site, :assets])) if defined?(Asset)
      else
        item(:'.sites', url_for([:admin, :sites]))
      end
    end

    def right
      if site.try(:persisted?)
        item(:'.settings', url_for([:edit, :admin, site]))
      end
    end

    protected

      def sites
        label(site.name, url_for([:admin, :sites])) do
          ul(:class => 'sites') do
            account.sites.each do |site|
              item(site.name, url_for([:admin, site])) unless site.new_record?
            end
            item(:'.new_site', url_for([:new, :admin, :site]))
            render_items
          end
        end
      end

      def sections
        item(:'.sections', url_for([:admin, site, :sections])) do
          ul(:class => 'sections') do
            site.sections.each do |section|
              item(section.name, url_for([:admin, site, section]), :class => :section)
            end
            item(:'.new_section', url_for([:new, :admin, site, :section]))
            render_items
          end
        end
      end

      def active?(url, options)
        return false if url =~ %r(/admin/sites$) && request.path !~ %r(/admin/sites(/\d+?)?$)
        super
      end

      def path_and_parents(path)
        paths = super
        paths.detect { |path| path.gsub!(/(#{Section.types.map(&:tableize).join('|')})$/) { 'sections' } }
        paths
      end
  end
end
