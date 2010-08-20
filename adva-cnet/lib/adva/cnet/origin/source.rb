module Adva
  class Cnet
    class Origin
      class Source
        class << self
          def load!(source, target)
            puts "loading data from #{source}"
            files = Dir["#{source}/**/*.txt"]
            files.each { |file| Source.new(file, target).load! }
          end
        end
        
        attr_reader :source, :target

        def initialize(source, target)
          @source, @target = source, target
        end
        
        def load!
          puts "loading data to #{table_name}"
          `echo '.mode csv\n.separator "\t"\n.import #{source} #{table_name}' | sqlite3 #{target}`
          # puts "#{table_name} #{count} rows"
          # values.each { |values| insert(values) }
        end
        
        def count
          Database.new(target).connection.select_values("select count(*) from #{table_name}")
        end
        
        # def insert(values)
        #   connection.execute("INSERT INTO #{table_name} (#{columns[0, values.size].join(', ')}) VALUES (#{values.join(', ')})")
        # end
        # 
        # def columns
        #   @columns ||= connection.columns(table_name).map(&:name)
        # end
        # 
        # def values
        #   @values ||= rows.map { |row| row.strip.split("\t").map { |value| connection.quote(value) } }
        # end
        # 
        # def rows
        #   @rows ||= File.open(filename, 'r') { |f| f.readlines }
        # end

        def table_name
          @table_name ||= begin
            name = "cds_#{File.basename(source, File.extname(source))}"
            name.downcase!
            name.gsub!('digital_content', 'digcontent')
            name.gsub!('language_links', 'lang_links')
            name.gsub!('languages', 'langs')
            name
          end
        end
      end
    end
  end
end