module Adva
  class Cnet
    class Origin
      class Database
        attr_reader :database
        
        delegate :connection, :to => :pool
        delegate :execute, :to => :connection
        
        def initialize(database, options = {})
          @database = database
          attach_database('main', options[:as]) if options[:as]
        end
        
        def pool
          @pool ||= begin
            ActiveRecord::Base.configurations[database.to_s] = { :adapter => 'sqlite3', :database => database.to_s }
            ActiveRecord::Base.establish_connection(database.to_s)
          end
        end
        
        def attach_database(name, alias_name)
          # this is sqlite3-specific...
          connection.execute("attach database \"#{name}\" as #{alias_name}")
        end
        
        def count(table_name)
          select_values("SELECT count(*) FROM #{table_name}").first.to_i
        end
    
        def insert(table_name, row)
          connection.execute("INSERT INTO #{table_name} VALUES (#{quote(row).join(', ')})")
        end
        
        def method_missing(method, *args, &block)
          method.to_s =~ /^select_/ ? _select(method, *args) : super
        end
        
        protected
        
          def _select(method, query)
            connection.send(method, replace_bound_variables(query))
          end
        
          def replace_bound_variables(query)
            query.is_a?(Array) ? query.first.gsub('?', quote(query.last).join(', ')) : query
          end
    
          def quote(values)
            values.map { |value| "'#{value}'" }
          end
      end
    end
  end
end