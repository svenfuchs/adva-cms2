out, Adva.out = Adva.out, $stdout

origin = Adva::Cnet::Connections.origin
origin.load('origin.schema.postgres.sql') if origin.tables.empty?
unless Adva::Cnet.normalize_path('origin.fixtures.sql').exist?
  Adva::Tasks::Cnet::Fixtures::Origin::Rebuild.new.run_all
end

import = Adva::Cnet::Connections.import
import.load('import.schema.sql') if import.tables.empty?
unless Adva::Cnet.normalize_path('import.fixtures.sql').exist?
  Adva::Tasks::Cnet::Fixtures::Import::Rebuild.new.run_all
end

origin.clear!
import.clear!

Adva.out = out
