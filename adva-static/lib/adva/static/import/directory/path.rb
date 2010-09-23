module Adva
  class Static
    module Import
      class Directory
        class Path < Pathname
          TYPES = ['yml', 'jekyll']
          EXTENSIONS = TYPES.map { |type| ".#{type}" }
          
          attr_reader :root

          def initialize(path, root = nil)
            @root = root || (path.respond_to?(:root) ? path.root : path)
            super(path || '')
          end

          def root?
            self.to_s == root.to_s
          end

          def local
            local = to_s.gsub(root, '')
            local = local[1..-1] if local[0, 1] == '/'
            Path.new(local.gsub(File.extname(local), ''))
          end

          def self_and_parents
            parents << self
          end

          def parents
            parts = local.to_s.split('/')[0..-2]
            parts.reverse.dup.inject([]) do |parents, part|
              # FIXME remove yml dependency
              parents.unshift(Path.new("#{root.join(parts.join('/'))}.yml", root)).tap do
                parts.delete(part)
              end
            end
          end

          def path
            local == 'index' ? '/' : "/#{local}"
          end

          def all
            Dir["#{self.to_s}/**/*"].map { |path| Path.new(path, self) }
          end

          def files
            @files ||= sub_paths.reject { |path| !File.file?(path) }
          end

          def dirs
            @dirs ||= sub_paths.reject { |path| !File.directory?(path) }
          end

          def sub_paths
            @sub_paths ||= Dir["#{self}/*"].map { |path| Path.new(path, self) }
          end

          def paths
            all.reject { |path| !EXTENSIONS.include?(File.extname(path)) || File.basename(path, EXTENSIONS) == 'site' }.sort
          end

          def join(other)
            self.class.new(super, root.is_a?(Path) ? root : Path.new(root))
          end

          def ==(other)
            to_s == other.to_s
          end

          def <=>(other)
            to_s <=> other.to_s
          end
        end
      end
    end
  end
end