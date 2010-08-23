require 'thor'
require 'thor/group'
require 'patches/thor/core_ext/hash'
require 'patches/thor/group/symbolized_options'

module Adva
  module Tasks
    class Cnet
      module Origin
        class Prepare < Thor::Group
          namespace 'adva:cnet:origin:prepare'
          desc 'Prepare origin database by loading cnet source files (e.g. full dump)'
          argument :source,  :required => false
          argument :target,  :required => false
          class_option :pattern, :required => false
    
          def stage
            Adva::Cnet::Origin::Prepare.new(source, target, :pattern => symbolized_options[:pattern]).run
          end
        end

        module Fixtures
          class Extract < Thor::Group
            namespace 'adva:cnet:origin:fixtures:extract'
            desc 'Extract test fixture data from a sqlite3 database file'
            argument :source, :required => false
            argument :target, :required => false
            argument :prod_ids, :required => false
      
            def extract
              prod_ids = self.prod_ids ? self.prod_ids.to_s.split(',').map(&:strip) : nil
              Adva::Cnet::Origin::Fixtures::Extract.new(source, target, prod_ids).run
            end
          end

          class Dump < Thor::Group
            namespace 'adva:cnet:origin:fixtures:dump'
            desc 'Dump test fixture data from a sqlite3 database file to an sql file'
            argument :source, :required => false
            argument :target, :required => false
      
            def extract
              Adva::Cnet::Origin::Fixtures.dump(source, target)
            end
          end

          class Load < Thor::Group
            namespace 'adva:cnet:origin:fixtures:load'
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
end