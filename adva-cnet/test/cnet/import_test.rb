require File.expand_path('../../test_helper', __FILE__)

require 'adva/cnet/origin'

module Tests
  module Cnet
    class ImportTest < Test::Unit::TestCase
      attr_reader :db

      def setup
        @db = Adva::Cnet::Origin::Database.new(':memory:')
        db.attach_database(":memory:", :origin)
        Adva::Cnet::Origin::Fixtures.load('origin.fixtures.sql', db.connection, :as => :origin)
        db.attach_database(":memory:", :import)
        Adva::Cnet::Origin::Fixtures.load('import.schema.sql', db.connection, :as => :import)
      end

      test "importing products" do
        assert_nothing_raised do
          db.connection.execute <<-sql
            INSERT INTO import.products (prod_id, cat_id) 
              SELECT "ProdID", "CatID" FROM origin.cds_prod
          sql
        end
      end
    end
  end
end