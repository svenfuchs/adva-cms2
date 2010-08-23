module Adva
  class Cnet
    class Origin
      module Sql
        class << self
          def dump(source, target)
            source = Cnet.normalize_path(source || 'db/cnet/origin.fixtures.sqlite3')
            target = Cnet.normalize_path(target || 'db/cnet/origin.fixtures.sql')

            `sqlite3 #{source} .dump > #{target}`
          end

          def load(source, target, options = {})
            source = Cnet.normalize_path(source || 'db/cnet/origin.fixtures.sql')

            if File.file?(target.to_s)
              `rm -f #{target}; sqlite3 #{target} < #{source}`
            else
              sql = File.read(source)
              sql = prepend_database_name(sql, options[:as]) if options[:as]
              sql.split(";\n").each { |line| target.execute(line) }
            end
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