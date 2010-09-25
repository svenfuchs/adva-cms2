module Adva
  class Static
    class Import
      module Model
        class Section < Base
          class << self
            def types
              [Blog, Page]
            end

            def recognize(sources)
              types.map { |type| type.recognize(sources) }.flatten.compact.sort
            end
          end

          def attribute_names
            [:site_id, :type, :name, :slug, :path]
          end

          def record
            @record ||= site.send(model.name.underscore.pluralize).find_or_initialize_by_path(path)
          end

          def site
            @site ||= Site.new(Source.new('site', source.root).find).record
          end

          def type
            model.name
          end

          def name
            @name ||= source.root? ? 'Home' : source.basename.titleize
          end

          def slug
            @slug ||= source.root? ? SimpleSlugs::Slug.new(name) : super
          end

          def path
            @path ||= source.root? ? slug : super
          end

          def loadable
            @loadable ||= source.root? ? Source.new('index', source.root).find.full_path : source.full_path
          end
        end
      end
    end
  end
end