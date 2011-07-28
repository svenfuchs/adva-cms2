require 'hashr'

module Adva
  class Static
    class Import
      module Source
        class Site < Base
          class << self
            def recognize(paths)
              paths.map { |path| new(path.delete(path).root) if path.filename == 'site' }.compact.sort # TODO ???
            end
          end

          def sections
            @sections ||= Section.recognize(path.glob.delete_if { |path| path.filename == 'site' })
          end

          def host
            @host ||= read.host || File.basename(path.root)
          end

          def name
            @name ||= read.name || host.titleize
          end

          def title
            @title ||= read.title || name
          end

          def data
            super.merge(:sections => sections, :host => host, :name => name, :title => title)
          end

          protected

            def loadable
              @loadable ||= path.join('site.yml')
            end
        end
      end
    end
  end
end

