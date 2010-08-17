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
            paths = path.all
            section_types.map { |type| type.detect(paths) }.flatten
          end
        end
          
        def loadable
          "#{self}/index.yml"
        end
      end
    end
  end
end