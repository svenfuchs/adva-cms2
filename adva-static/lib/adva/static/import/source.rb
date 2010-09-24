module Adva
  class Static
    module Import
      class Source < Pathname
        TYPES = ['html', 'jekyll', 'yml']
        EXTENSIONS = TYPES.map { |type| ".#{type}" }

        attr_reader :root

        def initialize(path, root = nil)
          root ||= path.root if path.respond_to?(:root)
          @root = Pathname.new(root.to_s)

          path = path.to_s.gsub(root, '') if root
          path = path.to_s[1..-1] if path.to_s[0, 1] == '/'
          super(path)
        end

        def root?
          self.to_s == root.to_s
        end

        def basename
          @basename ||= super.to_s.sub(/\.\w+$/, '')
        end
        
        def path
          @_path ||= dirname.join(basename).to_s
        end

        def self_and_parents
          parents << self
        end

        def parents
          @parents ||= begin
            parts = dirname.to_s.split('/')
            parts.reverse.dup.inject([]) do |parents, part|
              parents.unshift(Source.new(parts.join('/'), root)).tap do
                parts.delete(part)
              end
            end
          end
        end
      end
    end
  end
end