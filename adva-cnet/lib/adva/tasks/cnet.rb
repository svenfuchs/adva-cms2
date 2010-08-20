require 'thor'
require 'thor/group'
require 'patches/thor/core_ext/hash'
require 'patches/thor/group/symbolized_options'

module Adva
  module Tasks
    class Cnet
      module Fixtures
        class Prepare < Thor::Group
          namespace 'adva:cnet:fixtures:prepare'
          desc 'Prepare test fixture data extraction by generating an sqlite3 database file from cnet source files (e.g. full dump)'
          argument :source, :required => false
          argument :target, :required => false
      
          def prepare
            Adva::Cnet::Origin::Fixtures::Preparation.new(source, target).run
          end
        end

        class Extract < Thor::Group
          namespace 'adva:cnet:fixtures:extract'
          desc 'Extract test fixture data from a sqlite3 database file'
          argument :source, :required => false
          argument :target, :required => false
          argument :prod_ids, :required => false
      
          def extract
            prod_ids = self.prod_ids ? self.prod_ids.to_s.split(',').map(&:strip) : nil
            Adva::Cnet::Origin::Fixtures::Extraction.new(source, target, prod_ids).run
          end
        end

        class Dump < Thor::Group
          namespace 'adva:cnet:fixtures:dump'
          desc 'Dump test fixture data from a sqlite3 database file to an sql file'
          argument :source, :required => false
          argument :target, :required => false
      
          def extract
            Adva::Cnet::Origin::Fixtures.dump(source, target)
          end
        end

        class Load < Thor::Group
          namespace 'adva:cnet:fixtures:load'
          desc 'Load test fixture data to a database'
          argument :source, :required => false
          argument :target, :required => false
      
          def extract
            Adva::Cnet::Origin::Fixtures.load(source, target)
          end
        end
      end
    end
  end
end