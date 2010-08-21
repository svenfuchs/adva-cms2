module Adva
  module Importers
    class Directory
      class Section < Path
        include Loadable
        
        class << self
          def section_types
            [Blog, Page]
          end
          
          def build(path)
            paths = path.all.reject { |path| File.basename(path) == 'site.yml' }
            section_types.map { |type| type.build(paths) }.flatten.compact.sort
          end
        
          def dirname(path)
            File.dirname(path).tap { |dirname| dirname.replace('') if dirname == '.' }
          end
        end
          
        def loadable
          root? ? Path.new("#{self}/index.yml") : self
        end
        
        def title
          @title ||= root? ? 'Home' : local_path.to_s.titleize
        end
        
        def path
          root? ? 'home' : local_path.to_s # TODO can this be in local_path?
        end
      end
    end
  end
end