# require File.expand_path('../../test_helper', __FILE__)
# 
# module Tests
#   module Cnet
#     class ExtractorTest < Test::Unit::TestCase
#       include CnetTestHelper
# 
#       test "extracting products from origin to import" do
#         product = Adva::Cnet::Extractor::Product.new(db.connection, 'products')
#         product.run
#         assert_equal db.origin.count('cds_prod'), db.import.count('products')
#       end
#     end
#   end
# end