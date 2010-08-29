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

          @watcher  = fork { watch!(Adva.out) }
          at_exit { kill_watcher }
        end

        def call(env)
          status, headers, body = app.call(env)
          get_all(headers[PURGE_HEADER]) if headers.key?(PURGE_HEADER)
          [status, headers, body]
        end

        def update(path, event_type = nil)
          if event_type == :modified
            import = Adva::Importers::Directory::Import.new(dir, path, :routes => options[:routes])
            Adva.out.puts "\nmodified: #{path}"
            request('POST', import.request.path, import.request.params)
            request('GET', import.path.path)
          end
        end

        protected

          def get_all(paths)
            paths = paths.split(',') if paths.is_a?(String)
            Array(paths).each { |path| request('GET', path) }
          end

          def request(method, path, params = nil)
            Adva.out.puts "  #{method} #{path} "
            status, headers, response = call(env_for(method, path, params))
            Adva.out.puts "  => #{status} " + (status == 302 ? "(Location: #{headers['Location']})" : '')
            Adva.out.puts response if status == 500
          end

          def watch!(out)
            Dir.chdir(dir) do
              # $stdout = out
              handler = Watchr.handler.new
              handler.add_observer(self)
              Adva.out.puts "watching #{dir} for changes"
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
              :input => ::Rack::Utils.build_nested_query(params),
              'CONTENT_TYPE' => 'application/x-www-form-urlencoded',
              'HTTP_AUTHORIZATION' => 'Basic ' + ["#{username}:#{password}"].pack('m*')
            )
          end

          def username
            'admin@admin.org' # TODO read from conf/auth.yml or something
          end

          def password
            'admin'
          end

          def site
            @site ||= Site.first || raise('could not find any site') # FIXME
          end
      end
    end
  end
end