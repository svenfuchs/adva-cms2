module Adva
  class Cnet
    class Origin < ActiveRecord::Base
      module Schema
        class << self
          attr_reader :connection
          delegate :create_table, :add_index, :to => :connection
          
          def load!(connection)
            @connection = connection
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