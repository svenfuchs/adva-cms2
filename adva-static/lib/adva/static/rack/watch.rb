require 'watchr'

module Adva
  class Static
    module Rack
      class Watch
        autoload :Handler, 'adva/static/watch/handler'
        
        include Request

        attr_reader :app, :dir, :watch

        delegate :call, :to => :app

        def initialize(app, options = {}, &block)
          @app = app
          @dir = Pathname.new(options[:dir] || File.expand_path('import'))
          dir.mkpath

          @watch = fork { watch!(Adva.out) }
          at_exit { kill_watch }

          # trap_interrupt
          # Signal.trap('QUIT') { handler.refresh(watched_paths) }
        end

        def update(path, event_type = nil)
          Adva.out.puts "\n#{event_type}: #{path}"
          request = Adva::Static::Import::Directory.new(:source => dir).request_for(path)
          params  = request.params
          params.merge!('_method' => 'delete') if event_type == :deleted
          request('POST', request.path, params)
        end

        protected

          def watch!(out)
            Adva.out.puts "watching #{dir} for changes"
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
                STDERR.puts "\nReloading watched paths ... interrupt again to exit."
                handler.refresh(watched_paths)
              end
              @interrupt = Time.now
            end
            @interrupt = Time.now
          end

          def handler
            @handler ||= Adva::Static::Watch::Handler.new(self, dir.join('**/*.yml'))
          end

          def kill_watch
            Process.kill('TERM', watch)
          end

          def watched_paths
            paths = Dir[dir.join('**/*')].map {|path| Pathname(path).expand_path }
            paths << Pathname.new(__FILE__) if paths.empty?
            paths
          end
      end
    end
  end
end