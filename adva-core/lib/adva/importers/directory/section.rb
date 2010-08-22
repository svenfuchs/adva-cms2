module Adva
  module Importers
    class Directory
      class Section < Model
        class << self
          def types
            [Blog, Page]
          end

          def build(path)
            paths = path.all.reject { |path| File.basename(path) == 'site.yml' }
            types.map { |type| type.build(paths) }.flatten.compact.sort
          end
        end

        def loadable
          root? ? File.join(self, 'index.yml') : self
        end

        def title
          @title ||= root? ? 'Home' : local.to_s.titleize
        end

        def path
          root? ? 'home' : local.to_s # TODO can this be in local?
        end
      end
    end
  end
end