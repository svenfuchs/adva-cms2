# require File.expand_path('../../test_helper', __FILE__)
# 
# require 'adva/tasks/cnet'
# require 'adva/cnet/origin'
# require 'fileutils'
# 
# module Tests
#   module Cnet
#     class IntegrationTest < Test::Unit::TestCase
#       attr_reader :db
# 
#       def setup
#         Adva.out = STDOUT
#         # FileUtils.rm(tmp_db_path.join('origin.full.sqlite3')) rescue Errno::ENOENT
#         # FileUtils.rm(tmp_db_path.join('origin.fixtures.sqlite3')) rescue Errno::ENOENT
#         # @db = Adva::Cnet::Connection.new(':memory:')
#       end
# 
#       def teardown
#         # db.close
#         tmp_db_path.join('integration.fixtures.sqlite3').delete rescue Errno::ENOENT
#         tmp_db_path.join('integration.fixtures.sql').delete rescue Errno::ENOENT
#         tmp_db_path.join('integration.test.sqlite3').delete rescue Errno::ENOENT
#       end
# 
#       test "creating fixtures from new cnet dump and using them to import stuff" do
#         target = tmp_db_path.join('integration.full.sqlite3')
#         if !target.exist? || `sqlite3 #{target} 'SELECT COUNT(*) FROM cds_prod'`.chomp.to_i == 0
#           source  = 'origin.full.zip'
#           pattern = '**/{prod,mktde,stdnde,mspecde,especde}.txt'
#           Adva::Tasks::Cnet::Origin::Prepare.new([source, target], :pattern => pattern).invoke_all
#         end
#         assert `sqlite3 #{target} 'SELECT COUNT(*) FROM cds_prod'`.chomp.to_i > 0
#         # Adva::Cnet::Connection.new(target).close
# 
#         # EXTRACT FIXTURES
# 
#         source = tmp_db_path.join('integration.full.sqlite3')
#         target = tmp_db_path.join('integration.fixtures.sqlite3')
#         Adva::Tasks::Cnet::Origin::Fixtures::Extract.new([source, target]).invoke_all
#         assert_equal 5, `sqlite3 #{target} 'SELECT COUNT(*) FROM cds_prod'`.chomp.to_i
#         # source.close
#         # target.close
# 
#         # DUMP FIXTURES
# 
#         source = tmp_db_path.join('integration.fixtures.sqlite3')
#         target = tmp_db_path.join('integration.fixtures.sql')
#         Adva::Tasks::Cnet::Sql::Dump.new([source, target]).invoke_all
#         # source.close
#         # target.close
# 
#         # LOAD FIXTURES
# 
#         source = tmp_db_path.join('integration.fixtures.sql')
#         target = tmp_db_path.join('integration.test.sql')
#         Adva::Tasks::Cnet::Sql::Load.new([source, target]).invoke_all
#         # assert_equal 5, db.import.count('cds_prod')
#         # assert_equal 5, db.origin.count('cds_prod')
#         # assert_equal 5, db.count('cds_prod')
# 
#         # EXTRACT IMPORT
# 
#         # db.attach_database(":memory:", :origin)
#         # Adva::Cnet::Sql.load('origin.fixtures.sql', db.connection, :to => :origin)
#         # db.attach_database(":memory:", :import)
#         # Adva::Cnet::Sql.load('import.schema.sql', db.connection, :to => :import)
#         #
#         # Adva::Cnet::Extractor::Product.new(db.connection, 'products').run
#         # assert_equal db.count('origin.cds_prod'), db.count('import.products')
#       end
#     end
#   end
# end