require 'rack/utils'

module Adva
  class Static
    module Rack
      class Static < ::Rack::File
        attr_reader :app, :root

        def initialize(app, root)
          @app  = app
          @root = root
          Adva.out.puts "serving from #{root}"
        end

        def call(env)
          if get?(env) && path = static(env)
            super(env.merge('PATH_INFO' => path))
          else
            app.call(env)
          end
        end

        protected

          def static(env)
            path = env['PATH_INFO'].chomp('/')
            [path, "#{path}.html", "#{path}/index.html"].detect { |path| file?(path) }
          end

          def file?(path)
            File.file?(File.join(root, ::Rack::Utils.unescape(path)))
          end

          def get?(env)
            env['REQUEST_METHOD'] == 'GET'
          end
      end
    end
  end
end