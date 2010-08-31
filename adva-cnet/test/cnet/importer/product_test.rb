require File.expand_path('../../../test_helper', __FILE__)

module Tests
  module Cnet
    module Importer
      class ProductTest < Test::Unit::TestCase
        include CnetTestHelper

        def setup
          super
          import.load('import.fixtures.sql')
        end

        test "importing product updates for a single row from import to production" do
          Adva::Cnet::Importer::Product.new(:limit => 1, :order => :ext_product_id).run
          product = ::Cnet::Product.find_by_ext_product_id('100329')

          Globalize.with_locale('de') do
            expected = {
              "ext_product_id"           => "100329",
              "ext_category_id"          => "CA",
              "ext_manufacturer_id"      => "F00058",
              "manufacturer_name"        => "Samsung",
              "description"              => "Samsung SpinPoint P120 SP2514N - Festplatte - 250 GB - intern - 3.5\" - ATA-133 - 7200 rpm - Puffer: 8 MB",
              "manufacturer_part_number" => "SP2514N",
              "marketing_text"           => "Mit den Samsung SpinPoints erhalten Anwender höchste Speicherdichte und rasanten Datentransfer bei verblüffend geringer Geräuschentwicklung - ideal für Multimedia-Anwendungen und grafisch aufwändige Computerspiele.",
              "status"                   => nil
            }
            assert_equal expected, product.attributes.except('id', 'product_id', 'category_id', 'manufacturer_id', 'created_at', 'updated_at')
          end
        end

        test "importing product updates for multiple rows from import to production" do
          Adva::Cnet::Importer::Product.new(:limit => 5, :order => :ext_product_id).run
          products = ::Cnet::Product.all
          assert_equal 5, products.size

          Globalize.with_locale('de') do
            attribute_names = %w(ext_product_id ext_category_id ext_manufacturer_id 
              manufacturer_name description manufacturer_part_number marketing_text)
            products.each { |product| attribute_names.each { |name| assert_not_nil product.send(name) } }
          end
        end
      end
    end
  end
end