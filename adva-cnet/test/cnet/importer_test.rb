# require File.expand_path('../../test_helper', __FILE__)
# 
# module Tests
#   module Cnet
#     class ImporterTest < Test::Unit::TestCase
#       include CnetTestHelper
#       
#       def setup
#         super
#         Adva::Tasks::Cnet::Sql::Load.new(['origin.fixtures.sql', origin_path]).invoke_all
#         Adva::Cnet::Extractor::Product.new(import, 'products').run
#       end
# 
#       test "copying products from import to a temp table" do
#         assert_equal 5, import.count('products')
# 
#         product = Adva::Cnet::Importer::Product.new(db, 'products')
#         product.create_tmp_table
#         product.copy_data_to_tmp_table
# 
#         assert_equal 5, db.select_values("SELECT count(*) FROM #{product.tmp_table_name}").first.to_i
#       end
# 
#       test "importing new products from import to production" do
#         assert_equal 5, import.count('products')
#         assert_equal 0, production.count('products')
# 
#         product = Adva::Cnet::Importer::Product.new(production, 'products')
#         product.run
# 
#         assert_equal 5, production.count('products')
#       end
#     end
#   end
# end