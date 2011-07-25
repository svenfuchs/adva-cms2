module Adva
  class Static
    class Import
      module Source
        class Section < Base
          TYPES = [Blog, Page]

          class << self
            def recognize(paths)
              TYPES.map { |type| type.recognize(paths) }.flatten.compact.sort
            end
          end

          def root?
            path.root?
          end

          def categories
            read.categories || []
          end

          def name
            @name ||= read.name || (root? ? 'Home' : path.filename.to_s.titleize)
          end

          def slug
            @slug ||= read.slug || SimpleSlugs::Slug.new(name).to_s
          end

          def data
            super.merge(:categories => categories, :name => name, :slug => slug)
          end

          protected

            def loadable
              path.find('index') || path.parent.find(path.filename) || path
            end
        end
      end
    end
  end
end
