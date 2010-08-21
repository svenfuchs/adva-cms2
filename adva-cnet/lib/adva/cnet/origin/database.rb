module Adva
  class Cnet
    class Origin
      class Database
        attr_reader :database
        
        delegate :connection, :to => :pool
        
        def initialize(database)
          @database = database
          # Schema.load!(connection) if connection.tables.empty?
        end
        
        def pool
          @pool ||= begin
            id = "cnet_#{object_id}"
            ActiveRecord::Base.configurations[id] = { :adapter => 'sqlite3', :database => database }
            ActiveRecord::Base.establish_connection(id)
          end
        end
        
        def count(table_name)
          select_values("SELECT count(*) FROM #{table_name}").first.to_i
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
        
        def method_missing(method, *args, &block)
          method.to_s =~ /^select_/ ? _select(method, *args) : super
        end
        
        protected
        
          def _select(method, query)
            connection.send(method, replace_bind_variables(query))
          end
      end
    end
  end
end