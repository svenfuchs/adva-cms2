require File.expand_path('../../../test_helper', __FILE__)

module Tests
  module Cnet
    module Importer
      class ManufacturerTest < Test::Unit::TestCase
        include CnetTestHelper

        def setup
          super
          import.load('import.fixtures.sql')
        end

        test "extracting manufacturers from origin to import" do
          Adva::Cnet::Importer::Manufacturer.new.run
          manufacturer = ::Cnet::Manufacturer.find_by_ext_manufacturer_id('F00058')

          Globalize.with_locale('de') do
            expected = { 'ext_manufacturer_id' => 'F00058', 'name' => 'Samsung' }
            assert_equal expected, manufacturer.attributes.except('id', 'created_at', 'updated_at')
          end
        end
      end
    end
  end
end