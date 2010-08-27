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
          @dir = Pathname.new(options[:dir] || File.expand_path('import'))
          FileUtils.mkdir_p(dir)

          @watcher  = fork { watch!($stdout) }
          at_exit { kill_watcher }

          Admin::BaseController.skip_before_filter :authenticate_user! # TODO use http_auth?
        end

        def call(env)
          status, headers, body = app.call(env)
          get_all(headers[PURGE_HEADER]) if headers.key?(PURGE_HEADER)
          [status, headers, body]
        end

        def update(path, event_type = nil)
          if event_type == :modified
            import = importer.import(path)
            puts "\nmodified: #{path}"
            request('POST', import.request.path, import.request.params)
            request('GET', import.path.path)
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

          def request(method, path, params = nil)
            puts "  #{method} #{path} " # + (method == 'POST' ? "(#{params.inspect})" : '')
            status, headers, response = call(env_for(method, path, params))
            puts "  => #{status} " + (status == 302 ? "(Location: #{headers['Location']})" : '')
            puts response if status == 500
          end

          def watch!(stdout)
            Dir.chdir(dir) do
              $stdout = stdout
              handler = Watchr.handler.new
              handler.add_observer(self)
              puts "watching #{dir} for changes"
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

          def env_for(method, path, params)
            ::Rack::MockRequest.env_for("http://#{site.host}#{path}", :method => method,
              :input => ::Rack::Utils.build_nested_query(params))
          end

          def site
            @site ||= Site.first || raise('could not find any site') # FIXME
          end
      end
    end
  end
end