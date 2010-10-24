require 'active_support/core_ext/string/starts_ends_with'

module Adva
  module Rack
    class Static
      FILE_METHODS = %w(GET HEAD)
      STATIC_PATHS = %w(/images/adva /javascripts/adva /stylesheets/adva)

      attr_reader :app, :directories

      def initialize(app)
        @app = app
        @directories = Adva.engines.map { |engine| ::Rack::File.new(engine.root.join('public')) }
      end

      def call(env)
        path   = env['PATH_INFO'].chomp('/')
        method = env['REQUEST_METHOD']

        if FILE_METHODS.include?(method) && static?(path)
          if directory = directories.detect { |directory| exist?(directory, path) }
            return directory.call(env)
          else
            return not_found(path)
          end
        end

        app.call(env)
      end

      def static?(path)
        STATIC_PATHS.detect { |static_path| path.starts_with?(static_path)  }
      end

      def exist?(directory, path)
        File.file?(File.join(directory.root, ::Rack::Utils.unescape(path)))
      end

      def not_found(path)
        body = "File not found: #{path}\n"
        headers = {
          'Content-Type'   => 'text/plain',
          'Content-Length' => body.size.to_s,
          'X-Cascade'      => 'pass'
        }
        [404, headers, [body]]
      end
    end
  end
end
