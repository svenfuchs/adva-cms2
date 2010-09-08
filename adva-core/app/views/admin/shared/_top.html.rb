class Admin::Shared::Top < Adva::Views::Menu::Admin::Top
  def left
    item(:'.sites', url_for([:admin, :sites]))
    if site.persisted?
      item(:'.site',  url_for([:admin, site]))
      sections unless site.new_record?
    end
  end

  def right
    if site.persisted?
      item(:'.settings', url_for([:edit, :admin, site]))
    end
  end
  
  protected

    def sections
      item(:'.sections', url_for([:admin, site, :sections])) do
        ul do
          site.sections.each do |section|
            # TODO hu? inherited_resources seems to use build_section, so there's a new section in the collection??
            item(section.title, url_for([:admin, site, section])) unless section.new_record?
          end
        end
      end
    end

    def active?(url, options)
      return false if url =~ %r(/admin/sites(/\d+)?$) && request.path != url
      super
    end

    def path_and_parents(path)
      paths = super
      paths.detect { |path| path.gsub!(/(#{Section.types.map(&:tableize).join('|')})$/) { 'sections' } }
      paths
    end
end