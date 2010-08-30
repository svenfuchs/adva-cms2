module Adva
  class Cnet
    module Sql
      class << self
        def dump(source, target)
          target = Adva::Cnet.normalize_path(target) unless target.respond_to?(:stat)
          `pg_dump -a -x -T schema_migrations --inserts #{source.config[:database]} > #{target.to_s}`
        end

        def load(source, target, options = {})
          source = Adva::Cnet.normalize_path(source) unless source.respond_to?(:stat)
          File.read(source).split(";\n").each { |line| target.execute(line) }
        end
      end
    end
  end
end