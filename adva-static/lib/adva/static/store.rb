require 'fileutils'

module Adva
  class Static
    class Store
      attr_reader :dir

      def initialize(dir)
        @dir = Pathname.new(dir.to_s)
        FileUtils.rm_r(dir) rescue Errno::ENOENT
      end

      def exists?(path)
        File.exists?(dir.join(path.filename))
      end

      def write(path, body)
        path = dir.join(path.filename)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w+') { |f| f.write(body) }
      end
    end
  end
end