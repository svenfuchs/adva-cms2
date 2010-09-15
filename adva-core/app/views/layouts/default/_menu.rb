class Layouts::Default::Menu < Adva::View::Menu
  def to_html
    ul(:id => :menu) do
      site.sections.each do |section|
        item(section.title, url_for(section))
      end
    end
  end
  
  protected

    def active?(url, options)
      return false if url =~ %r(/admin/sites(/\d+)?$) && request.fullpath != url
      super
    end
    
    # def path_and_parents(path)
    #   paths = super
    #   paths.detect { |path| path.gsub!(/(#{Section.types.map(&:tableize).join('|')})$/) { 'sections' } }
    #   paths
    # end
end