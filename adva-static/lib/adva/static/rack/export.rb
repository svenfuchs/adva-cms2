require 'fileutils'

module Adva
  class Static
    module Rack
      class Export
        attr_reader :app, :target, :store

        def initialize(app, options = {})
          @app = app
          @target = Pathname.new(options[:target] || File.expand_path('./export'))
          @store  = Static::Store.new(target)
        end

        def call(env)
          app.call(env).tap do |status, headers, body|
            export(env['PATH_INFO'], body) if status == 200
            purge(headers[PURGE_HEADER]) if paths = headers.key?(PURGE_HEADER)
          end
        end

        protected

          def export(path, body)
            page = Page.new(path, body)
            store.write(page.url, page.body)
          end

          def purge(paths)
            normalize_paths(paths).each do |path|
              store.purge(Path.new(path))
            end
          end
          
          def normalize_paths(paths)
            paths = paths.split(',') if paths.is_a?(String)
            Array(paths)
          end
      end
    end
  end
end