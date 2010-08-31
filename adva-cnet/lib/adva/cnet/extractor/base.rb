# TODO:
# - abstract index creation using "select indexdef from pg_catalog.pg_indexes where name = #{name}"

module Adva
  class Cnet
    module Extractor
      class Base
        attr_reader :table_name
        
        def initialize
          @table_name = "cnet_#{self.class.name.demodulize.tableize}"
        end

        def connection
          Connections.import
        end

        def run
          without_indexes do
            insert_statements('de').each { |statement| connection.execute(statement) }
          end
        end

        protected

          def insert_statements(locale)
            Array.wrap(origin_select_statements).map do |statement|
              <<-sql
                INSERT INTO #{table_name} (#{column_list}, locale)
                  SELECT *, '#{locale}' FROM dblink('cnet_origin', E'#{escape_inner_query(statement)}')
                  AS t1 (#{column_definition_list})
              sql
            end
          end

          def columns
            @columns ||= Hash[*connection.columns(table_name).map { |value| [value.name, value] }.flatten]
          end

          def column_list
            @column_list ||= column_names.join(', ')
          end

          def column_definition_list
            column_names.map { |name| "#{name} #{columns[name].sql_type}" }.join(', ')
          end
        
          def without_indexes
            drop_indexes
            yield
            create_indexes
          end

          def drop_indexes
            connection.execute(indexes.map { |index| "DROP INDEX #{index.name}" }.join(';'))
          end

          def create_indexes
            connection.execute(indexes.map { |index| "CREATE INDEX #{index.name} ON (#{index.columns.join(', ')})" }.join(';'))
          end
        
          def indexes
            connection.connection.indexes(table_name)
          end

          def escape_inner_query(sql)
            sql.gsub(/(')/) { "\\#{$1}" }
          end
      end
    end
  end
end