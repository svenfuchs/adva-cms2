module Adva
  module Importers
    class Directory
      class Path < Pathname
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
          local.to_s.split('/')[0..-2].map { |path| Path.new("#{root.join(path)}.yml", root) }
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
          all.reject { |path| File.extname(path) != '.yml' || File.basename(path) == 'site.yml' }.sort
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