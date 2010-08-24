# require File.expand_path('../../test_helper', __FILE__)
# 
# require 'adva/cnet/origin'
# 
# module Tests
#   module Cnet
#     class OriginTest < Test::Unit::TestCase
#       attr_reader :origin
# 
#       def setup
#         @origin = Adva::Cnet::Origin::Database.new(':memory:')
#         Adva::Cnet::Origin::Sql.load('origin.fixtures.sql', origin.connection)
#       end
# 
#       test "loading product fixtures to origin database works" do
#         assert origin.count('cds_prod') > 0
#         assert_equal '100329', origin.select_values('SELECT ProdID FROM cds_prod LIMIT 1').first
#       end
# 
#       test "loading stdn fixtures to origin database works" do
#         assert origin.count('cds_stdnde') > 0
# 
#         description = origin.select_values('SELECT Description FROM cds_stdnde WHERE ProdID = "100329" LIMIT 1').first
#         assert_equal 'Samsung SpinPoint P120 SP2514N - Festplatte - 250 GB - intern - 3.5" - ATA-133 - 7200 rpm - Puffer: 8 MB', description
#       end
# 
#       test "loading mkt fixtures to origin database works" do
#         assert origin.count('cds_mktde') > 0
# 
#         mkt_id = origin.select_values('SELECT MktID FROM cds_prod WHERE ProdID = "100329" LIMIT 1').first
#         actual = origin.select_values("SELECT Description FROM cds_mktde WHERE MktID = '#{mkt_id}' LIMIT 1").first
#         expected = 'Mit den Samsung SpinPoints erhalten Anwender h?chste Speicherdichte und rasanten Datentransfer ' +
#                    'bei verbl?ffend geringer Ger?uschentwicklung - ideal f?r Multimedia-Anwendungen und grafisch ' +
#                    'aufw?ndige Computerspiele.'
# 
#         # FIXME fix encondings!
#         # assert_equal expected, actual
#       end
# 
#       test "loading mspec fixtures to origin database works" do
#         assert origin.count('cds_mspecde') > 0
# 
#         hdr_id, body_id = origin.select_all('SELECT HdrID, BodyID FROM cds_mspecde WHERE ProdID = "100329" LIMIT 1').
#           first.values_at('HdrID', 'BodyID')
#         assert_equal ["T0000002", "B0774481"], [hdr_id, body_id]
# 
#         hdr  = origin.select_values('SELECT Text FROM cds_mvocde WHERE ID = "T0000002" LIMIT 1').first
#         body = origin.select_values('SELECT Text FROM cds_mvocde WHERE ID = "B0774481" LIMIT 1').first
# 
#         assert_equal 'Produktbeschreibung', hdr
#         assert_equal 'Samsung SpinPoint P120 SP2514N - Festplatte - 250 GB - ATA-133', body
#       end
# 
#       test "loading espec fixtures to origin database works" do
#         assert origin.count('cds_especde') > 0
# 
#         sect_id, hdr_id, body_id = origin.select_all('SELECT SectID, HdrID, BodyID FROM cds_especde WHERE ProdID = "100329" LIMIT 1').
#           first.values_at('SectID', 'HdrID', 'BodyID')
#         assert_equal ['H0000002', 'T0000094', 'B0214150'], [sect_id, hdr_id, body_id]
# 
#         sect = origin.select_values('SELECT Text FROM cds_evocde WHERE ID = "H0000002" LIMIT 1').first
#         hdr  = origin.select_values('SELECT Text FROM cds_evocde WHERE ID = "T0000094" LIMIT 1').first
#         body = origin.select_values('SELECT Text FROM cds_evocde WHERE ID = "B0214150" LIMIT 1').first
# 
#         assert_equal 'Allgemein', sect
#         # FIXME fix encondings!
#         # assert_equal 'Gerätetyp', hdr
#         assert_equal 'Festplatte - intern', body
#       end
#     end
#   end
# end