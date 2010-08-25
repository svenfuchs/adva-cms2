# require File.expand_path('../../test_helper', __FILE__)
# 
# require 'adva/cnet/origin'
# 
# module Tests
#   module Cnet
#     class ExtractorTest < Test::Unit::TestCase
#       attr_reader :db, :origin, :import
# 
#       def setup
#         @db = Adva::Cnet::Connection.new(tmp_db_path.join('origin.extractor.sqlite3'))
#         db.attach_databases
#         @origin, @import = db.origin, db.import
#         
#         origin.load('origin.fixtures.sql')
#         import.load('import.schema.sql')
#       end
#       
#       def teardown
#         db.close
#         FileUtils.rm(tmp_db_path.join('origin.extractor.sqlite3')) rescue Errno::ENOENT
#       end
# 
#       def product
#         Adva::Cnet::Extractor::Product.new(db.connection, 'products')
#       end
# 
#       test "extracting products from origin to import" do
#         product.run
#         assert_equal origin.count('cds_prod'), import.count('products')
#       end
#     end
#   end
# end