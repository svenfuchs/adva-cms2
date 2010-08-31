require File.expand_path('../../../test_helper', __FILE__)

module Tests
  module Cnet
    module Extractor
      class ManufacturerTest < Test::Unit::TestCase
        include CnetTestHelper

        def setup
          super
          origin.load('origin.fixtures.sql')
        end
      
        test "extracting manufacturers from origin to import" do
          Adva::Cnet::Extractor::Manufacturer.new.run

          expected = {
            'ext_manufacturer_id' => 'F00058', 
            'name'                => 'Samsung', 
            'locale'              => 'de'
          }
          actual = import.select_all("SELECT * FROM cnet_manufacturers WHERE ext_manufacturer_id = 'F00058'").first
          assert_equal expected, actual
        end
      end
    end
  end
end