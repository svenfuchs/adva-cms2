require File.expand_path('../../../test_helper', __FILE__)

module Tests
  module Cnet
    module Extractor
      class AttributeTest < Test::Unit::TestCase
        include CnetTestHelper

        def setup
          super
          origin.load('origin.fixtures.sql')
        end

        test "extracting mspec attribute updates from origin to import" do
          Adva::Cnet::Extractor::Attribute.new.run

          expected = {
            'locale'          => 'de',
            'ext_value_id'    => 'mspec--T0000002-100329-B0774481',
            'ext_category_id' => nil,
            'section_name'    => nil,
            'key_name'        => 'Produktbeschreibung',
            'numeric_value'   => nil,
            'unit'            => nil,
            'display_value'   => 'Samsung SpinPoint P120 SP2514N - Festplatte - 250 GB - ATA-133',
            'sort_order'      => '1'
          }
          query  = %q(
            SELECT * FROM cnet_attributes
            WHERE ext_value_id = 'mspec--T0000002-100329-B0774481'
            ORDER BY ext_value_id LIMIT 1
          )
          actual = import.select_all(query).first
          assert_equal expected, actual
        end

        test "extracting espec attribute updates from origin to import" do
          Adva::Cnet::Extractor::Attribute.new.run

          expected = {
            'locale'          => 'de',
            'ext_value_id'    => 'espec-H0000002-T0000019-100329-B0000299',
            'ext_category_id' => nil,
            'section_name'    => 'Allgemein',
            'key_name'        => 'Tiefe',
            'numeric_value'   => nil,
            'unit'            => nil,
            'display_value'   => '14.6 cm',
            'sort_order'      => '3'
          }
          query  = %q(
            SELECT * FROM cnet_attributes
            WHERE ext_value_id = 'espec-H0000002-T0000019-100329-B0000299'
            ORDER BY ext_value_id LIMIT 1
          )
          actual = import.select_all(query).first
          assert_equal expected, actual
        end
      end
    end
  end
end
