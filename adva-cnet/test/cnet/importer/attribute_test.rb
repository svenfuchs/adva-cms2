require File.expand_path('../../../test_helper', __FILE__)

module Tests
  module Cnet
    module Importer
      class AttributeTest < Test::Unit::TestCase
        include CnetTestHelper

        def setup
          super
          import.load('import.fixtures.sql')
          create_product(%w(101467 101468 101469 101496 502440))
        end

        test "importing attribute updates for multiple rows from import to production" do
          Adva::Cnet::Importer::Attribute.new(:limit => 5, :order => :ext_value_id).run
          espec = ::Attributes::Key.find_by_ext_key_id("espec")

          Globalize.with_locale('de') do
            assert_equal 4, ::Attributes::Key.count
            assert_not_nil espec
            assert_not_nil espec.children
            assert_not_nil espec.children.first.children
            assert_equal 5, ::Attributes::Value.count
          end

          Globalize.with_locale('de') do
            value = ::Attributes::Value.find_by_ext_value_id('espec-H0000002-T0000018-100329-B0000508')
            assert_equal '100329', value.ext_product_id
            assert_equal '10.2 cm', value.display_value
          end
        end
      end
    end
  end
end