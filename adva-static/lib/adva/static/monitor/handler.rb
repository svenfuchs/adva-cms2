require 'observer'
require 'watchr'
require 'watchr/event_handlers/portable'

module Adva
  class Static
    module Monitor
      class Handler
        include Observable

        def initialize(observable, pattern)
          add_observer(observable)
          @pattern = pattern
          @current = Dir[pattern]
          @mtime   = Time.now
        end

        def listen
          loop { trigger; sleep(0.5) }
        end

        def trigger
          events.each do |path, event|
            changed(true)
            notify_observers(path, event)
          end
        end

        protected

          def events
            @last    = @current.dup
            @current = Dir[@pattern]
            created + modified + deleted
          end

          def modified
            (@current & @last).each do |path|
              mtime = File.mtime(path)
              if mtime > @mtime
                @mtime = mtime
                return [[path, :modified]]
              end
            end && []
          end

          def created
            (@current - @last).map { |path| [path, :created] }
          end

          def deleted
            (@last - @current).map { |path| [path, :deleted] }
          end
      end
    end
  end
end