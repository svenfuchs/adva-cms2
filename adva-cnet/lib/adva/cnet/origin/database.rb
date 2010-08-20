module Adva
  class Cnet
    class Origin
      class Database
        attr_reader :database
        
        delegate :connection, :to => :pool
        
        def initialize(database)
          @database = database
          
          Schema.load!(connection) if connection.tables.empty?
        end
        
        def pool
          @pool = begin
            id = "cnet_#{object_id}"
            ActiveRecord::Base.configurations[id] = { :adapter => 'sqlite3', :database => database }
            ActiveRecord::Base.establish_connection(id)
          end
        end

        def select_rows(query)
          connection.select_rows(replace_bind_variables(query))
        end

        def select_values(query)
          connection.select_values(replace_bind_variables(query))
        end
    
        def insert(table_name, row)
          connection.execute("INSERT INTO #{table_name} VALUES (#{quote(row).join(', ')})")
        end
        
        def replace_bind_variables(query)
          query.is_a?(Array) ? query.first.gsub('?', quote(query.last).join(', ')) : query
        end
    
        def quote(values)
          values.map { |value| "'#{value}'" }
        end
      end
    end
  end
end