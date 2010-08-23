require File.expand_path('../../test_helper', __FILE__)

require 'adva/tasks/cnet'
require 'adva/cnet/origin'
require 'stringio'

module Tests
  module Cnet
    class IntegrationTest < Test::Unit::TestCase
      attr_reader :db

      def setup
        @db = Adva::Cnet::Origin::Database.new(':memory:')
        Adva::Cnet.out = StringIO.new('')
      end
      
      def prepare!
        source  = 'origin.full.zip'
        target  = 'origin.full.sqlite3'
        pattern = '**/{prod,mktde,stdnde,mspecde,especde}.txt'
        Adva::Tasks::Cnet::Origin::Prepare.new([source, target], :pattern => pattern).invoke_all
      end
      
      def extract_fixtures!
        source = 'origin.full.sqlite3'
        target = 'origin.fixtures.sqlite3'
        Adva::Tasks::Cnet::Origin::Fixtures::Extract.new([source, target]).invoke_all
      end
      
      def dump_fixtures!
        source = 'origin.fixtures.sqlite3'
        target = 'origin.fixtures.sql'
        Adva::Tasks::Cnet::Origin::Fixtures::Dump.new([source, target]).invoke_all
      end
      
      def load_fixtures!
        source = 'origin.fixtures.sql'
        target = db.connection
        Adva::Tasks::Cnet::Origin::Fixtures::Load.new([source, target]).invoke_all
      end
      
      test "creating fixtures from new cnet dump and using them to import stuff" do
        assert_nothing_raised do
          
          # comment this in to generate origin.full.sqlite3 as well
          # prepare!

          extract_fixtures!
          dump_fixtures!
          load_fixtures!
        
          db.attach_database(":memory:", :origin)
          Adva::Cnet::Origin::Fixtures.load('origin.fixtures.sql', db.connection, :as => :origin)
          db.attach_database(":memory:", :import)
          Adva::Cnet::Origin::Fixtures.load('import.schema.sql', db.connection, :as => :import)

          db.connection.execute <<-sql
            INSERT INTO import.products (prod_id, cat_id)
              SELECT "ProdID", "CatID" FROM origin.cds_prod
          sql
        end
      end
    end
  end
end