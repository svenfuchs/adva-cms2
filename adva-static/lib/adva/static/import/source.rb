module Adva
  class Static
    class Import
      class Source < Pathname
        TYPES = ['html', 'jekyll', 'yml']
        EXTENSIONS = TYPES.map { |type| ".#{type}" }

        attr_reader :root

        delegate :exist?, :to => :full_path

        def initialize(path, root = nil)
          root ||= path.root if path.respond_to?(:root)
          @root = Pathname.new(root.to_s)

          path = path.to_s.gsub(root, '') if root
          path = path.to_s[1..-1] if path.to_s[0, 1] == '/'
          super(path)
        end

        def find_or_self
          find or self
        end

        def find
          file = Dir["#{root.join(path)}.{#{TYPES.join(',')}}"].first
          Source.new(file, root) if file
        end

        def all
          @all ||= Dir[root.join(path).join("**/*.{#{TYPES.join(',')}}")].map { |path| Source.new(path, root) }
        end

        def files
          files = path == 'index' ? directory.all : all
          files.reject { |path| path.basename == 'site' }.sort
        end

        def root?
          @_root ||= path == 'index' || full_path.to_s == root.to_s
        end

        def directory
          @directory ||= self.class.new(dirname, root)
        end

        def basename
          @basename ||= super.to_s.sub(/\.\w+$/, '')
        end

        def dirname
          @dirname ||= super.to_s.sub(/^.$/, '')
        end

        def path
          @_path ||= [dirname, basename].select(&:present?).join('/')
        end

        def full_path
          @full_path ||= root.join(self)
        end

        def self_and_parents
          parents << self
        end

        def parents
          @parents ||= begin
            parts = self.to_s.split('/')[0..-2]
            parts.inject([]) do |parents, part|
              parents << Source.new(parts[0..parents.size].join('/'), root)
            end
          end
        end

        def <=>(other)
          path == 'index' ? -1 : other.path == 'index' ? 1 : path <=> other.path
        end
      end
    end
  end
end
