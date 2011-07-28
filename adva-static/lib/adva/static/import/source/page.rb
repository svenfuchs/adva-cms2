module Adva
  class Static
    class Import
      module Source
        class Page < Section
          class << self
            def recognize(paths)
              paths.map { |path| new(path) }
            end
          end
        end
      end
    end
  end
end


