module Adva
  class Static
    module Import
      module Model
        class Section < Base
          # TYPES = [Blog, Page]

          class << self
            def recognize(paths)
              TYPES.map { |type| type.recognize(paths) }.flatten.compact.sort
            end
          end

          def record
            @record ||= site.sections.find_or_initialize_by_type_and_path(model.name.underscore.pluralize, path)
          end

          def site
            @site ||= Site.new(Source.new('site.yml', source.root)).record
          end

          def type
            model.name
          end

          def name
            @name ||= source.root? ? 'Home' : source.basename.titleize
          end

          def path
            source.root? ? 'home' : source.path
          end

          def loadable
            # source.root? ? Dir["#{source}/index.{#{Source::TYPES.join(',')}}"].first : source
          end
        end
      end
    end
  end
end