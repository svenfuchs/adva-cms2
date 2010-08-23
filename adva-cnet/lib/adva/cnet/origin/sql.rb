module Adva
  class Cnet
    class Origin
      module Sql
        class << self
          def load(source, target, options = {})
            source || raise(ArgumentError, 'source must not be nil')
            source = Cnet.normalize_path(source)

            sql = File.read(source)
            sql = prepend_database_name(sql, options[:as]) if options[:as]
            sql.split(";\n").each { |line| target.execute(line) }
            # `rm -f #{target}; sqlite3 #{target} < #{source}`
          end

          protected

            def prepend_database_name(sql, name)
              pattern = /(CREATE TABLE|CREATE INDEX|INSERT INTO) /i
              sql.gsub!(pattern) { "#{$1} #{name}." }
            end
        end
      end
    end
  end
end