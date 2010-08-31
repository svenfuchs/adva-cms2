module Adva
  class Cnet
    module Finalizer
      class Base
        attr_reader :table_name

        def run
          synchronize_foreign_keys
        end
        
        def synchronize_foreign_keys
          Array(synchronize_foreign_key_statements).each do |sql|
            ActiveRecord::Base.connection.execute(sql)
          end
        end

        def synchronize_foreign_key_statement(key, subselect)
          "UPDATE #{table_name} SET #{key} = (#{subselect}) WHERE #{key} IS NULL"
        end
      end
    end
  end
end