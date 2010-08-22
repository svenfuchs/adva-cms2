module Adva
  module Importers
    class Directory
      class Path < Pathname
        attr_reader :root
        
        def initialize(path, root = nil)
          @root = root || (path.respond_to?(:root) ? path.root : path)
          super(path)
        end

        def root?
          self.to_s == root.to_s
        end
        
        def local
          local = to_s.gsub(root, '')
          local = local[1..-1] if local[0, 1] == '/'
          self.class.new(local.gsub(File.extname(local), ''))
        end
        
        def all
          Dir["#{self}/**/*"].map { |path| Path.new(path, self) }
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
        
        def join(other)
          self.class.new(super, root.is_a?(Path) ? root : Path.new(root))
        end
        
        def <=>(other)
          to_s <=> other.to_s
        end
      end
    end
  end
end