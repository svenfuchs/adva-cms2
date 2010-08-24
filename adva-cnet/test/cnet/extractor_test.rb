# require File.expand_path('../../test_helper', __FILE__)
# 
# require 'adva/cnet/origin'
# 
# module Tests
#   module Cnet
#     class ExtractorTest < Test::Unit::TestCase
#       attr_reader :db
# 
#       def setup
#         @db = Adva::Cnet::Origin::Database.new(':memory:')
#         db.attach_database(":memory:", :origin)
#         Adva::Cnet::Origin::Sql.load('origin.fixtures.sql', db.connection, :as => :origin)
#         db.attach_database(":memory:", :import)
#         Adva::Cnet::Origin::Sql.load('import.schema.sql', db.connection, :as => :import)
#       end
#       
#       def product
#         Adva::Cnet::Extractor::Product.new(db.connection, 'products')
#       end
# 
#       test "extracting products from origin to import" do
#         product.run
#         assert_equal db.count('origin.cds_prod'), db.count('import.products')
#       end
#     end
#   end
# end