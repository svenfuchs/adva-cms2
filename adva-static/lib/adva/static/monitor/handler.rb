require 'watchr'
require 'watchr/event_handlers/portable'

module Adva
  class Static
    module Monitor
      class Handler < ::Watchr::EventHandler::Portable
        def listen(root, pattern)
          @root, @pattern = root, pattern
          @monitored_paths = glob
          loop { trigger; sleep(0.25) }
        end

        def glob
          paths = Dir[@root.join(@pattern)].map {|path| Pathname(path).expand_path }
          paths << Pathname.new(__FILE__) if paths.empty?
          paths
        end


        def detect_event
          if path = (glob - @monitored_paths).first
            @monitored_paths << path
            return [path, :created]
          end
          
          @monitored_paths.each do |path|
            unless path.exist?
              @monitored_paths.delete(path)
              return [path, :deleted]
            end
          end

          mtime_path = @monitored_paths.max { |a,b| a.mtime <=> b.mtime }
          # ctime_path = @paths.max { |a,b| a.ctime <=> b.ctime }
          # atime_path = @paths.max { |a,b| a.atime <=> b.atime }

          if    mtime_path.mtime > @reference_mtime then @reference_mtime = mtime_path.mtime; [mtime_path, :modified]
          # elsif ctime_path.ctime > @ctime then @ctime = ctime_path.ctime; [ctime_path, :changed ]
          # elsif atime_path.atime > @atime then @atime = atime_path.atime; [atime_path, :accessed]
          else; nil; end
        rescue Errno::ENOENT
          retry
        end
      end
    end
  end
end


# require 'observer'
# require 'ruby-debug'
#
# module Adva
#   class Static
#     module Monitor
#       class Handler
#         include Observable
#
#         def initialize(observable, root)
#           add_observer(observable)
#           @root = root
#           @mtime, @atime, @ctime = Time.now, Time.now, Time.now
#           @paths = glob
#         end
#
#         def listen
#           loop { trigger; sleep(0.5) }
#         end
#
#         def trigger
#           path, type = detect_event
#           notify(path, type) unless path.nil?
#         end
#
#         private
#
#           def glob
#             Dir[@root.join('**/*.yml')].map { |path| Pathname.new(path) }
#           end
#
#         def detect_event
#           puts "detecting ..."
#           # unless path = (glob - @paths).first
#           #   @paths << path
#           #   return [path, :created]
#           # end
#           #
#           # @paths.each do |path|
#           #   unless path.exist?
#           #     @paths.delete(path)
#           #     return [path, :deleted]
#           #   end
#           # end
#
#           mtime_path = @paths.max { |a,b| a.mtime <=> b.mtime }
#           # ctime_path = @paths.max { |a,b| a.ctime <=> b.ctime }
#           # atime_path = @paths.max { |a,b| a.atime <=> b.atime }
# p mtime_path
# p mtime_path.mtime > @mtime
#           if    mtime_path.mtime > @mtime then @mtime = mtime_path.mtime; [mtime_path, :modified]
#           # elsif ctime_path.ctime > @ctime then @ctime = ctime_path.ctime; [ctime_path, :changed ]
#           # elsif atime_path.atime > @atime then @atime = atime_path.atime; [atime_path, :accessed]
#           else; nil; end
#         rescue Errno::ENOENT
#           retry
#         end
#       end
#     end
#   end
# end