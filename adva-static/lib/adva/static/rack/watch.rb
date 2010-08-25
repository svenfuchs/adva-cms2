require 'fileutils'
require 'watchr'

Watchr::EventHandler::Portable.class_eval do
  def listen(monitored_paths)
    @monitored_paths = monitored_paths
    loop { trigger; sleep(0.1) }
  end
end

module Adva
  class Static
    module Rack
      class Watch
        attr_reader :app, :dir, :options

        def initialize(app, options = {}, &block)
          @app = app
          @options = options
          @dir = Pathname.new(options[:dir] || File.expand_path('./import'))
          FileUtils.mkdir_p(dir)

          @watcher  = fork { watch!($stdout) }
          at_exit { kill_watcher }
        end

        def call(env)
          status, headers, body = app.call(env)
          get_all(headers[PURGE_HEADER]) if headers.key?(PURGE_HEADER)
          [status, headers, body]
        end

        def update(path, event_type = nil)
          if event_type == :modified
            attributes = importer.recognize_file(path).attributes
            query = ::Rack::Utils.build_nested_query(attributes)
            request('POST', "#{path}?#{query}", attributes)
            # request('GET', path.to_s)
          end
        end

        protected

          def importer
            @importer ||= Adva::Importers::Directory.new(dir, :routes => options[:routes])
          end
          
          def get_all(paths)
            paths = paths.split(',') if paths.is_a?(String)
            Array(paths).each { |path| request('GET', path) }
          end

          def request(method, path, attributes = {})
            call(env_for(path).merge('REQUEST_METHOD' => method).merge(attributes))
          end

          def watch!(stdout)
            Dir.chdir(dir) do
              $stdout = stdout
              handler = Watchr.handler.new
              handler.add_observer(self)
              handler.listen(monitored_paths)
            end
          rescue SignalException, SystemExit
          rescue Exception => e
            p e
            e.backtrace.each { |line| puts line }
          end

          def kill_watcher
            Process.kill('TERM', @watcher)
          end

          def monitored_paths
            paths = Dir[dir.join('**/*')].map {|path| Pathname(path).expand_path }
            paths << Pathname.new(__FILE__) if paths.empty?
            paths
          end

          def env_for(path)
            name, port = site.host.split(':')
            ::Rack::MockRequest.env_for(path).merge('SERVER_NAME' => name,'SERVER_PORT' => port || '80')
          end
          
          def site
            @site ||= Site.first || raise('could not find any site') # FIXME
          end
      end
    end
  end
end