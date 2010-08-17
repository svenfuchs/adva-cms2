module Adva
  class Cnet
    class Origin < ActiveRecord::Base
      module Schema
        class << self
          delegate :connection, :to => Origin
          delegate :create_table, :add_index, :to => :connection

          def load!
            instance_eval(schema)
          end

          def schema
            File.read(File.expand_path('db/schema/cnet.origin.rb', Adva::Cnet.root))
          end
        end
      end
    end
  end
end