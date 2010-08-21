module Adva
  module Importers
    class Directory
      class Path < Pathname
        STATIC_DIRS = %w(images javascripts stylesheets)
        
        attr_reader :root, :record
        
        def initialize(path, root = nil)
          @root = root || (path.respond_to?(:root) ? path.root : path)
          super(path)
        end
        
        def all
          Dir["#{self}/**/*"].map { |path| Path.new(path, self) }
        end
        
        def subdirs
          @subdirs ||= Dir["#{self}/*"].map { |path| Path.new(path, self) }
        end

        def files
          @files ||= subdirs.reject { |path| !File.file?(path) }
        end
        
        def dirs
          @dirs ||= subdirs.reject { |path| !File.directory?(path) }
        end

        def non_static_dirs
          @non_static_dirs ||= dirs.reject { |path| path.static? }
        end

        def root?
          self.to_s == root.to_s
        end
        
        def static?
          STATIC_DIRS.include?(local_path.to_s)
        end
        
        def join(other)
          self.class.new(super, root.is_a?(Path) ? root : Path.new(root))
        end
        
        def local_path
          local_path = to_s.gsub(root, '')
          local_path = local_path[1..-1] if local_path[0, 1] == '/'
          self.class.new(local_path.gsub(File.extname(local_path), ''))
        end
        
        def <=>(other)
          to_s <=> other.to_s
        end
        
        def updated_at
          self.mtime
        end

        def slug
          File.basename(self)
        end
      end
    end
  end
end