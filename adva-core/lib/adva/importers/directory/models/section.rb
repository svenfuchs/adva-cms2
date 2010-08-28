module Adva
  module Importers
    class Directory
      module Models
        class Section < Base
          class << self
            def types
              [Blog, Page]
            end

            def build(root)
              paths = root.all.reject { |path| File.extname(path) != '.yml' || File.basename(path) == 'site.yml' }
              paths = paths.sort

              sections = types.map { |type| type.build(paths) }.flatten.compact.sort
              sections << new(Path.new('home', root)) if sections.empty?
              sections
            end
          end

          def record
            @record ||= site.send(association).find_or_initialize_by_path(path)
          end

          def site
            @site ||= Site.new(source.root).record
          end

          def loadable
            source.root? ? File.join(source, 'index.yml') : source
          end

          def type
            model.name
          end

          def title
            @title ||= source.root? ? 'Home' : File.basename(source.local).to_s.titleize
          end

          def path
            source.root? ? 'home' : source.local.to_s # TODO can this be in local?
          end

          def association
            model.name.underscore.pluralize
          end
        end
      end
    end
  end
end