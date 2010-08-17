module Adva
  class Cnet
    class Origin
      class Source
        class << self
          def load!(dir)
            files = Dir[File.expand_path("#{dir}/**/*.txt")]
            files.each { |file| Source.new(Origin.connection, file).load! }
          end
        end
        
        attr_reader :connection, :filename

        def initialize(connection, filename)
          @connection, @filename = connection, filename
        end
        
        def load!
          puts "loading data to #{table_name}"
          values.each { |values| insert(values) }
        end
        
        def insert(values)
          connection.execute("INSERT INTO #{table_name} VALUES (#{values.join(', ')})")
        end
        
        def values
          rows.map { |row| row.strip.split("\t").map { |value| connection.quote(value) } }
        end

        def rows
          File.open(filename, 'r') { |f| f.readlines }
        end

        def table_name
          @table_name ||= "cds_#{File.basename(filename, File.extname(filename))}"
        end
      end
    end
  end
end