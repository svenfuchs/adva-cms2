module Adva
  class Cnet
    class Connection
      attr_reader :connection

      def initialize(connection, options = {})
        @connection = connection
        link(options[:with_link]) if options[:with_link]
      end

      def config
        connection.instance_variable_get(:@config)
      end

      def link(name)
        load_dblink unless dblink_loaded?
        config = ActiveRecord::Base.configurations[name]
        execute("SELECT dblink_connect('#{name}', 'dbname=#{name} user=#{config[:username]} password=#{config[:password]}');")
      end

      def prepare(source, options = {})
        Prepare::Origin.new(source, self, options).load
      end

      def load(path, options = {})
        Sql.load(path, self, options)
      end

      def dump(path)
        Sql.dump(self, path)
      end

      def clear!
        execute("TRUNCATE #{tables.join(',')}")
      end

      def tables
        connection.tables.reject { |table| table.start_with?('pg_') }
      end

      def count(table_name)
        select_values("SELECT COUNT(*) FROM #{table_name}").first.to_i
      end

      def insert(table_name, row, options = {})
        connection.execute("INSERT INTO #{table_name} VALUES (#{quote(row).join(', ')})")
      end

      def with_encoding(encoding)
        transaction do
          set_encoding(encoding)
          yield
          reset_encoding
        end
      end

      def set_encoding(encoding)
        execute "SET CLIENT_ENCODING TO '#{encoding}'"
      end

      def reset_encoding
        execute "RESET CLIENT_ENCODING"
      end

      def respond_to?(method)
        connection.respond_to?(method) || super
      end

      def method_missing(method, *args, &block)
        return super unless connection.respond_to?(method)
        args[0] = replace_bound_variables(args[0]) if method.to_s =~ /^select_/
        connection.send(method, *args, &block)
      end

      protected

        def replace_bound_variables(query)
          query.is_a?(Array) ? query.first.gsub('?', quote(query.last).join(', ')) : query
        end

        def quote(values)
          values.map { |value| "'#{value}'" }
        end

        def load_dblink
          puts "Loading dblink functions to #{config[:database]}"
          system("psql -d #{config[:database]} -f `pg_config --sharedir`/contrib/dblink.sql > /dev/null")
        end

        def dblink_loaded?
          select_value("SELECT proname FROM pg_catalog.pg_proc WHERE proname = 'dblink'")
        end
    end
  end
end