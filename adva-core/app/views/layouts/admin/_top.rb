class Layouts::Admin::Top < Adva::View::Menu::Admin
  id :top

  def main
    # item(:'.sites', url_for([:admin, :sites]))
    if site.try(:persisted?)
      sites
      # item(:'.site',  url_for([:admin, site]))
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
          # label(:'.sites')
          account.sites.each do |site|
            item(site.name, url_for([:admin, site])) unless site.new_record?
          end
          item(:'.new_site', url_for([:new, :admin, :site]))
        end
      end
    end

    def sections
      item(:'.sections', url_for([:admin, site, :sections])) do
        ul(:class => 'sections') do
          site.sections.each do |section|
            # TODO hu? inherited_resources seems to use build_section, so there's a new section in the collection??
            item(section.title, url_for([:admin, site, section]), :class => :section) unless section.new_record?
          end
          item(:'.new_section', url_for([:new, :admin, site, :section]))
        end
      end
    end

    def active?(url, options)
      # return false if url =~ %r(/admin/sites(/\d+)?$) && request.path != url
      return false if url =~ %r(/admin/sites$) && request.path !~ %r(/admin/sites(/\d+?)?$)
      super
    end

    def path_and_parents(path)
      paths = super
      paths.detect { |path| path.gsub!(/(#{Section.types.map(&:tableize).join('|')})$/) { 'sections' } }
      paths
    end
end