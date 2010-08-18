module Adva
  module Importers
    class Directory
      class Section < Path
        include Loadable
        
        class << self
          def section_types
            [Blog, Page]
          end
          
          def detect(path)
            paths = path.all.reject { |path| File.basename(path) == 'site.yml' }
            sections = section_types.map { |type| type.detect(paths) }.flatten
            root = sections.detect { |section| section.root? }
            
            # FIXME should really build up the sectin tree
            # sections.each { |section| section.section.parent = root.section }
            sections.delete(root)
            sections.unshift(root)
            sections.compact
          end
        end
          
        def loadable
          Path.new("#{self}/index.yml")
        end
        
        def title
          @title ||= root? ? 'Home' : local_path.to_s.titleize
        end
      end
    end
  end
end