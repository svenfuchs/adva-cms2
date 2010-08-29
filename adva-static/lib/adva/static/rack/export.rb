require 'fileutils'

module Adva
  class Static
    module Rack
      class Export
        include Request

        attr_reader :app, :target, :store

        def initialize(app, options = {})
          @app = app
          @target = Pathname.new(options[:target] || File.expand_path('./export'))
          @store  = Adva::Static::Store.new(target)
        end

        def call(env)
          path = env['PATH_INFO'].dup # gets modified by routing_filter
          app.call(env).tap do |status, headers, body|
            export(path, body) if export?(env, status)
            if headers.key?(PURGE_HEADER)
              paths = normalize_paths(headers[PURGE_HEADER])
              paths.each do |path| 
                purge(path)
                request('GET', path, STORE_HEADER => true)
              end
            end
          end
        end

        protected

          def export?(env, status)
            env[STORE_HEADER].present? and status == 200
          end

          def export(path, body)
            page = Page.new(path, body)
            Adva.out.puts "  storing #{page.url.filename}"
            store.write(page.url, page.body)
          end

          def purge(path)
            Adva.out.puts "  purging #{path}"
            store.purge(Path.new(path))
          end

          def normalize_paths(paths)
            paths = paths.split(',') if paths.is_a?(String)
            Array(paths)
          end
      end
    end
  end
end