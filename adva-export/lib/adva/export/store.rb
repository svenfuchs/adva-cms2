module Adva
  class Export
    class Store
      attr_reader :dir

      def initialize(dir)
        @dir = Pathname.new(dir.to_s)
      end

      def exists?(path)
        dir.join(normalize_path(path)).exist?
      end

      def write(path, body)
        path = dir.join(normalize_path(path))
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w+') { |f| f.write(body) }
      end

      protected

        def normalize_path(path)
          path[0, 1] == '/' ? path.to_s[1..-1] : path
        end
    end
  end
end