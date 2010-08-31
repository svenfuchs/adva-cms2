require 'thor'
require 'thor/group'
require 'patches/thor/core_ext/hash'
require 'patches/thor/group/symbolized_options'

module Adva
  module Tasks
    module Cnet
      module Prepare
        class Origin < Thor::Group
          namespace 'adva:cnet:prepare:origin'
          desc 'Prepare origin database by loading cnet source files (e.g. full dump)'
          class_option :source,  :required => false, :default => 'origin.full.zip'
          class_option :target,  :required => false, :default => 'origin'
          class_option :pattern, :required => false

          def prepare
            target = Adva::Cnet::Connections.send(target)
            target.prepare(source, :pattern => symbolized_options[:pattern])
          end
        end
      end

      module Fixtures
        module Origin
          class Extract < Thor::Group
            namespace 'adva:cnet:fixtures:origin:extract'
            desc 'Extract origin test fixture sql dump from a database file to'
            class_option :source, :required => false, :default => 'origin'
            class_option :target, :required => false, :default => 'origin.fixtures.sql'
            class_option :prod_ids, :required => false
          
            def extract
              source = Adva::Cnet::Connections.send(symbolized_options[:source])
              tmp    = Adva::Cnet::Connections.tmp
              Adva::Cnet::Fixtures::Origin.new(source, tmp, symbolized_options[:prod_ids]).extract
              tmp.dump(symbolized_options[:target])
            end
          end

          class Rebuild < Thor::Group
            namespace 'adva:cnet:fixtures:origin:rebuild'
            desc 'Rebuild origin fixtures sql dump from cnet source files (e.g. full dump)'
            class_option :source, :required => false, :default => 'origin.full.zip'
            class_option :target, :required => false, :default => 'origin.fixtures.sql'
            class_option :prod_ids, :required => false
            class_option :pattern, :required => false

            def rebuild
              origin = Adva::Cnet::Connections.origin
              tmp    = Adva::Cnet::Connections.tmp

              origin.prepare(symbolized_options[:source], :pattern => symbolized_options[:pattern])
              Adva::Cnet::Fixtures::Origin.new(origin, tmp, symbolized_options[:prod_ids]).extract
              tmp.dump(symbolized_options[:target])
            end
          end
        end

        module Import
          class Rebuild < Thor::Group
            namespace 'adva:cnet:fixtures:import:rebuild'
            desc 'Rebuild import fixtures sql dump from cnet source files (e.g. full dump)'
            class_option :source, :required => false, :default => 'origin.fixtures.sql'
            class_option :target, :required => false, :default => 'import.fixtures.sql'
            class_option :prod_ids, :required => false
            class_option :pattern, :required => false

            def rebuild
              Adva::Cnet::Connections.origin.clear!
              Adva::Cnet::Connections.import.clear!

              Adva::Cnet::Connections.origin.load(symbolized_options[:source])
              %w(Attribute Manufacturer Product).each do |name|
                Adva::Cnet::Extractor.const_get(name).new.run
              end
              Adva::Cnet::Connections.import.dump(symbolized_options[:target])
            end
          end
        end
      end

      module Sql
        class Dump < Thor::Group
          namespace 'adva:cnet:sql:dump'
          desc 'Dump a database file to a sql file'
          argument :source, :required => true
          argument :target, :required => true

          def dump
            source = Adva::Cnet::Connections.send(source)
            Adva::Cnet::Sql.dump(source, target)
          end
        end

        class Load < Thor::Group
          namespace 'adva:cnet:sql:load'
          desc 'Load a sql file to a database'
          argument :source, :required => true
          argument :target, :required => true

          def load
            target = Adva::Cnet::Connections.send(target)
            Adva::Cnet::Sql.load(source, target)
          end
        end
      end
    end
  end
end