# require File.expand_path('../../test_helper', __FILE__)
# 
# module Tests
#   module Cnet
#     class IntegrationTest < Test::Unit::TestCase
#       include CnetTestHelper
# 
#       def setup
#         super
#         # Adva.out = STDOUT
#       end
# 
#       test "creating fixtures from new cnet dump and using them to import stuff" do
# 
#         # PREPARE ORIGIN
# 
#         source  = 'origin.full.zip'
#         target  = full_path
#         # pattern = '**/{prod,mktde,stdnde,mspecde,especde}.txt'
#         pattern = '**/{prod}.txt'
# 
#         assert_equal 0, full.count('cds_prod')
#         Adva::Tasks::Cnet::Origin::Prepare.new([source, target], :pattern => pattern).invoke_all
#         assert full.count('cds_prod') > 0
# 
#         # EXTRACT FIXTURES
#         source = full
#         target = fixtures
# 
#         assert_equal 0, fixtures.count('cds_prod')
#         Adva::Tasks::Cnet::Origin::Fixtures::Extract.new([full, fixtures]).invoke_all
# 
#         assert_equal 5, fixtures.count('cds_prod')
# 
#         # DUMP FIXTURES
# 
#         source = fixtures_path
#         target = CnetTestHelper.db_dir.join('integration.fixtures.sql')
# 
#         Adva::Tasks::Cnet::Sql::Dump.new([source, target]).invoke_all
#         sql = File.read(target)
#         assert_match    /INSERT INTO "cds_prod"/,  sql
#         assert_no_match /CREATE TABLE "cds_prod"/, sql
# 
#         # LOAD FIXTURES
# 
#         source = CnetTestHelper.db_dir.join('integration.fixtures.sql')
#         target = origin_path
#         assert_equal 0, origin.count('cds_prod')
#         Adva::Tasks::Cnet::Sql::Load.new([source, target]).invoke_all
#         assert_equal 5, origin.count('cds_prod')
# 
#         # EXTRACT IMPORT
# 
#         Adva::Cnet::Extractor::Product.new(import, 'products').run
#         assert_equal 5, import.count('products')
# 
#         product = import.select_all('SELECT * FROM products LIMIT 1').first
# 
#         assert_equal 'F00058',   product['mf_id']
#         assert_equal 'D4648527', product['mkt_id']
#         assert_equal '100329',   product['product_number']
#         assert_equal 'I311014',  product['img_id']
#         assert_equal 'CA',       product['cat_id']
#         assert_equal 'SP2514N',  product['manufacturer_part_number']
#         
#         # IMPORT TO PRODUCTION
# 
#         Adva::Cnet::Importer::Product.new(import, 'products').run
#         assert_equal 5, import.count('products')
#       end
#     end
#   end
# end