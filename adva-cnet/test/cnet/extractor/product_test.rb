require File.expand_path('../../../test_helper', __FILE__)

module Tests
  module Cnet
    module Extractor
      class ProductTest < Test::Unit::TestCase
        include CnetTestHelper

        def setup
          super
          origin.load('origin.fixtures.sql')
        end

        test "extracting products from origin to import" do
          Adva::Cnet::Extractor::Product.new.run

          assert_equal origin.count('cds_prod'), import.count('cnet_products')
          
          expected = {
            'locale'                   => 'de',
            "ext_product_id"           => "100329", 
            "ext_category_id"          => "CA", 
            "ext_manufacturer_id"      => "F00058", 
            "manufacturer_part_number" => "SP2514N", 
            "manufacturer_name"        => "Samsung", 
            "status"                   => nil, 
            "description"              => "Samsung SpinPoint P120 SP2514N - Festplatte - 250 GB - intern - 3.5\" - ATA-133 - 7200 rpm - Puffer: 8 MB",
            "marketing_text"           => 
              'Mit den Samsung SpinPoints erhalten Anwender höchste Speicherdichte ' +
              'und rasanten Datentransfer bei verblüffend geringer Geräuschentwicklung - ' +
              'ideal für Multimedia-Anwendungen und grafisch aufwändige Computerspiele.'
          }
          actual = import.select_all('SELECT * FROM cnet_products ORDER BY ext_product_id LIMIT 1').first.except('id')
          assert_equal expected, actual
        end
      end
    end
  end
end