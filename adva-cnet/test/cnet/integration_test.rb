require File.expand_path('../../test_helper', __FILE__)

require 'adva/tasks/cnet'
require 'adva/cnet/origin'
require 'fileutils'

module Tests
  module Cnet
    class IntegrationTest < Test::Unit::TestCase
      attr_reader :db

      def setup
        @db = Adva::Cnet::Origin::Database.new(':memory:')
      end

      test "creating fixtures from new cnet dump and using them to import stuff" do
        target = tmp_dir.join('origin.full.sqlite3')
        unless target.exist?
          source  = 'origin.full.zip'
          pattern = '**/{prod,mktde,stdnde,mspecde,especde}.txt'
          Adva::Tasks::Cnet::Origin::Prepare.new([source, target], :pattern => pattern).invoke_all
        end
        assert `sqlite3 #{target} 'SELECT COUNT(*) FROM cds_prod'`.chomp.to_i > 0

        # EXTRACT FIXTURES

        source = tmp_dir.join('origin.full.sqlite3')
        target = tmp_dir.join('origin.fixtures.sqlite3')
        Adva::Tasks::Cnet::Origin::Fixtures::Extract.new([source, target]).invoke_all
        assert_equal 5, `sqlite3 #{target} 'SELECT COUNT(*) FROM cds_prod'`.chomp.to_i

        # DUMP FIXTURES

        source = tmp_dir.join('origin.fixtures.sqlite3')
        target = tmp_dir.join('origin.fixtures.sql')
        Adva::Tasks::Cnet::Origin::Sql::Dump.new([source, target]).invoke_all

        # LOAD FIXTURES

        source = tmp_dir.join('origin.fixtures.sql')
        # target = ':memory:'
        target = db.connection
        Adva::Tasks::Cnet::Origin::Sql::Load.new([source, target]).invoke_all
        assert_equal 5, db.count('cds_prod')

        # EXTRACT IMPORT

        # db.attach_database(":memory:", :origin)
        # Adva::Cnet::Origin::Sql.load('origin.fixtures.sql', db.connection, :as => :origin)
        # db.attach_database(":memory:", :import)
        # Adva::Cnet::Origin::Sql.load('import.schema.sql', db.connection, :as => :import)
        #
        # Adva::Cnet::Extractor::Product.new(db.connection, 'products').run
        # assert_equal db.count('origin.cds_prod'), db.count('import.products')
      end

      protected

        def tmp_dir
          Pathname.new('/tmp/adva-cnet-test/db').tap { |path| FileUtils.mkdir_p(path) }
        end
    end
  end
end