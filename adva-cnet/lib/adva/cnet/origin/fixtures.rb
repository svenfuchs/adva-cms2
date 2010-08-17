module Adva
  class Cnet
    class Origin
      module Fixtures
        class << self
          def extract(dir)
            Schema.load!
            Adva::Cnet::Origin::Source.load!(dir)
          end
        end
      end
    end
  end
end