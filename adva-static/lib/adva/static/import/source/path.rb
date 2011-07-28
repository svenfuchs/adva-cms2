module Adva
  class Static
    class Import
      module Source
        class Path < Pathname
          TYPES = ['html', 'jekyll', 'yml']
          EXTENSIONS = TYPES.map { |type| ".#{type}" }

          attr_reader :root

          def initialize(path, root = nil)
            super(path)
            @root = self.class.new(root.to_s) if root && to_s != root.to_s
          end

          def root?
            !@root || filename == 'index' && parent.root? || @root.to_s == to_s # i.e. this is the root path if no root is set
          end

          def root
            root? ? self : @root
          end

          def parent
            self.class.new(super, @root || self)
          end

          def self_and_parents
            parents << self
          end

          def parents
            parts = to_s.split('/')[0..-2]
            parts.inject([]) { |parents, part| parents << self.class.new(parts[0..parents.size].join('/'), root) }
          end

          def self_and_descendants
            [self] + descendants
          end

          def descendants
            Dir[join("**/*.{#{TYPES.join(',')}}")].map { |child| join(child.gsub(/#{to_s}\/?/, '')) }
          end

          def local
            gsub(root ? "#{root}/" : '', '')
          end

          def filename
            basename.gsub(extname, '')
          end

          def join(other)
            self.class.new(super, root)
            # self.class.new(super(other.gsub(/^\//, '')), root)
          end

          def gsub(pattern, replacement)
            self.class.new(to_s.gsub(pattern, replacement), root)
          end

          def glob
            paths = Dir[join('**/*')].map { |child| join(child.gsub("#{to_s}/", '')) }
            paths = paths.map { |path| path.filename == 'index' ? path.parent : path }
            paths.sort
          end

          def find(name)
            path = Dir["#{join(name)}.{#{TYPES.join(',')}}"].first
            self.class.new(path, root) if path
          end

          def <=>(other)
            root? ? -1 : other.root? ? 1 : to_s <=> other.to_s
          end

          def ==(other)
            to_s == other.to_s
          end
        end
      end
    end
  end
end
