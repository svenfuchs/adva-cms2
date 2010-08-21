module Adva
  module Importers
    class Directory
      class Page < Section
        PATTERN = %r(/[\w-]+\.yml$)
        
        class << self
          def build(paths)
            return [] if paths.empty?
            root  = paths.first.root
            pages = paths.select { |path| path.to_s =~ PATTERN }
            paths.replace(paths - pages)
            pages.map { |path| new(path, root) }.uniq
          end
        end
        
        def initialize(path, root = nil)
          path = File.dirname(path) if File.basename(path, File.extname(path)) == 'index'
          super
        end
        
        def section
          @section ||= ::Page.new(:path => path, :title => title, :article => Article.new(:title => title, :body => body))
        end
        
        def body
          @body || ''
        end
      end
    end
  end
end