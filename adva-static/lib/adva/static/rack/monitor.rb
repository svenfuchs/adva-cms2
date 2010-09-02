require 'watchr'

module Adva
  class Static
    module Rack
      class Monitor
        autoload :Handler, 'adva/static/monitor/handler'
        
        include Request

        attr_reader :app, :dir, :monitor

        delegate :call, :to => :app

        def initialize(app, options = {}, &block)
          @app = app
          @dir = Pathname.new(options[:dir] || File.expand_path('import'))
          dir.mkpath

          @monitor = fork { monitor!(Adva.out) }
          at_exit { kill_monitor }

          # trap_interrupt
          # Signal.trap('QUIT') { handler.refresh(monitored_paths) }
        end

        def update(path, event_type = nil)
          Adva.out.puts "\n#{event_type}: #{path}"
          request = Adva::Static::Import::Directory.new(dir).request_for(path)
          params  = request.params
          params.merge!('_method' => 'delete') if event_type == :deleted
          request('POST', request.path, params)
        end

        protected

          def monitor!(out)
            Adva.out.puts "monitoring #{dir} for changes"
            Dir.chdir(dir) { handler.listen }
          rescue SignalException, SystemExit
          rescue Exception => e
            p e
            e.backtrace.each { |line| puts line }
          end

          def trap_interrupt
            Signal.trap('INT') do
              if Time.now - @interrupt < 1
                exit
              else
                STDERR.puts "\nReloading monitored paths ... interrupt again to exit."
                handler.refresh(monitored_paths)
              end
              @interrupt = Time.now
            end
            @interrupt = Time.now
          end

          def handler
            @handler ||= Adva::Static::Monitor::Handler.new(self, dir.join('**/*.yml'))
          end

          def kill_monitor
            Process.kill('TERM', monitor)
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