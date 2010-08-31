module Adva
  class Cnet
    module Importer
      class Base
        attr_reader :table_name, :where, :limit, :order

        def initialize(options = {})
          @where = options[:where]
          @limit = options[:limit]
          @order = options[:order]
          @table_name = "cnet_#{self.class.name.demodulize.tableize}"
        end

        def run
          rows = Connections.import.select_all(query)
          rows.each { |row| self.class::Row.new(row).import }
        end
        
        def query
          query = "SELECT * FROM #{table_name} "
          query += "WHERE #{where} " if where
          query += "ORDER BY #{order} " if order
          query += "LIMIT #{limit} " if limit
          query
        end
        
        class Row
          attr_reader :attributes

          def initialize(attributes)
            @attributes = attributes
          end
        end
      end
    end
  end
end