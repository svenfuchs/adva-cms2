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
          run!
        end

        def update(path, event_type = nil)
          Adva.out.puts "\n#{event_type}: #{path}"
          import  = Adva::Static::Import.new(:source => dir)
          request = import.request_for(path)
          status, headers, response = self.request('POST', request.path, request.params)
          response = get(path) if !request.destroy? && status == 302
        rescue Exception => e
          Adva.out.puts e.message
          e.backtrace.each { |line| Adva.out.puts line }
        end

        def get(path)
          import  = Adva::Static::Import.new(:source => dir)
          request = import.request_for(path)
          self.request('GET', request.public_path, STORE_HEADER => true)
        rescue Exception => e
          Adva.out.puts e.message
          e.backtrace.each { |line| Adva.out.puts line }
        end

        protected

          def run!
            @watch = fork { watch!(Adva.out) }
            at_exit { kill_watch }
          end

          def watch!(out)
            Adva.out.puts "watching #{dir} for changes"
            Dir.chdir(dir)
            handler.listen
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
            @handler ||= Adva::Static::Watch::Handler.new(self, dir.join("**/*.{#{Import::Source::Path::TYPES.join(',')}}"))
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
