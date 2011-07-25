module Adva
  class Static
    class Import
      module Model
        class Page < Section
          def attribute_names
            @attribute_names ||= super + [:body]
          end
        end
      end
    end
  end
end
