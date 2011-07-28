require 'hashr'

module Adva
  class Static
    class Import
      module Source
        class Base
          delegate :exist?, :to => :path

          attr_reader :path

          def initialize(path)
            @path = normalize_path(path)
          end

          def to_hash
            data
          end

          def data
            @data ||= Hashr.new(read || {})
          end

          def model_name
            @model_name ||= self.class.name.demodulize
          end

          def <=>(other)
            path <=> other.path
          end

          protected

            def normalize_path(path)
              path = path.is_a?(Path) ? path : Path.new(path)
              path = path.parent if path.filename == 'index'
              path
            end

            def loadable
              raise "path #{path.inspect} is not a file" unless path.file?
              path
            end

            def read
              @read ||= begin
                format = Format.for(loadable) if loadable.exist?
                data = format.read if format
                Hashr.new(data || {})
              end
            end
        end
      end
    end
  end
end



