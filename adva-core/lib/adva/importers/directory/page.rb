module Adva
  module Importers
    class Directory
      class Page < Section
        PATTERN = %r(/[\w-]+\.yml$)
        
        class << self
          def accept?(path)
            # if path.to_s =~ %r(/([\w-]+).yml$) and $1 != 'index'
            #   p path
            # end
            false
          end

          def detect(paths)
            pages = paths.select { |path| path.to_s =~ PATTERN }
            paths.replace(paths - pages)
            pages.map { |path| new(File.dirname(path)) }
          end
        end

        def section
          @section ||= ::Page.new(:title => title, :article => Article.new(:title => title))
        end

        def title
          root? ? 'Home' : local_path.to_s.titleize
        end
      end
    end
  end
end