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
        include Request

        attr_reader :app, :dir, :routes, :watcher

        delegate :call, :to => :app

        def initialize(app, options = {}, &block)
          @app = app
          @routes = options[:routes]
          @dir = Pathname.new(options[:dir] || File.expand_path('import'))
          FileUtils.mkdir_p(dir)

          @watcher = fork { watch!(Adva.out) }
          at_exit { kill_watcher }
        end

        def update(path, event_type = nil)
          if event_type == :modified
            Adva.out.puts "\nmodified: #{path}"
            import = Adva::Importers::Directory::Import.new(dir, path, :routes => routes)
            request('POST', import.request.path, import.request.params)
          end
        end

        protected

          def watch!(out)
            Adva.out.puts "watching #{dir} for changes"
            Dir.chdir(dir) { handler.listen(monitored_paths) }
          rescue SignalException, SystemExit
          rescue Exception => e
            p e
            e.backtrace.each { |line| puts line }
          end

          def handler
            Watchr.handler.new.tap { |handler| handler.add_observer(self) }
          end

          def kill_watcher
            Process.kill('TERM', watcher)
          end

          def monitored_paths
            paths = Dir[dir.join('**/*')].map {|path| Pathname(path).expand_path }
            paths << Pathname.new(__FILE__) if paths.empty?
            paths
          end
      end
    end
  end
end