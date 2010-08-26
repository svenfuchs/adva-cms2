module Adva
  class Cnet
    class Connection
      class DatabaseProxy
        instance_methods.each { |m| undef_method(m) unless %w(__send__ __id__ inspect respond_to?).include?(m) }

        attr_reader :connection, :name

        def initialize(connection, name)
          @connection, @name = connection, name
        end

        def load(path, options = {})
          Sql.load(path, database, options)
        end

        def database
          c = connection.connection.instance_variable_get(:@connection)
          c.database_list.detect { |db| db['name'] == name.to_s }['file']
        end

        def respond_to?(method)
          connection.respond_to?(method) || super
        end

        def method_missing(method, *args, &block)
          options = args.extract_options!.merge(:as => name)
          connection.send(method, *(args << options), &block)
        end
      end

      attr_reader :database

      delegate :connection, :to => :pool
      delegate :execute, :to => :connection

      @@pool ||= {}

      def initialize(database, options = {})
        @database = database.to_s
      end

      def databases
        connection.instance_variable_get(:@connection).database_list.map { |db| db['name'] }
      end

      def attach_database(name, alias_name)
        connection.execute("attach database \"#{name}\" as #{alias_name}") unless alias_name == 'main'
        (class << self; self; end).class_eval <<-rb
          def #{alias_name}; @#{alias_name} ||= DatabaseProxy.new(self, :#{alias_name}); end
        rb
      end

      def close
        @@pool.delete(database)
      end

      def load(path, options = {})
        Sql.load(path, connection, options)
      end

      def count(table_name, options = {})
        select_values(using(options[:as], "SELECT count(*) FROM #{table_name}")).first.to_i
      end

      def insert(table_name, row, options = {})
        connection.execute(using(options[:as], "INSERT INTO #{table_name} VALUES (#{quote(row).join(', ')})"))
      end

      def import
        @import ||= DatabaseProxy.new(self, :import)
      end

      def method_missing(method, *args, &block)
        method.to_s =~ /^select_/ ? _select(method, *args) : super
      end

      protected

        def pool
          @@pool[database] ||= begin
            ActiveRecord::Base.configurations[database] = { :adapter => 'sqlite3', :database => database }
            ActiveRecord::Base.establish_connection(database)
          end
        end

        def _select(method, query, options = {})
          query = using(options[:as], replace_bound_variables(query))
          connection.send(method, query)
        end

        def replace_bound_variables(query)
          query.is_a?(Array) ? query.first.gsub('?', quote(query.last).join(', ')) : query
        end

        def quote(values)
          values.map { |value| "'#{value}'" }
        end

        def using(database, sql)
          database ? sql.gsub(/(CREATE TABLE|CREATE INDEX|INSERT INTO|FROM) /i) { "#{$1} #{database}." } : sql
        end

      # def attach_databases
      #   %w(origin import).each { |name| attach_database(database, name) }
      # end

      # def detach_databases
      #   %w(origin import).each { |name| detach_database(name) }
      # end

      # def detach_database(name)
      #   connection.execute("detach database \"#{name}\"")
      # end
    end
  end
end