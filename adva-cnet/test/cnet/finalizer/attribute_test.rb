require File.expand_path('../../../test_helper', __FILE__)

module Tests
  module Cnet
    module Finalizer
      class AttributeTest < Test::Unit::TestCase
        include CnetTestHelper

        def setup
          super
          import.load('import.fixtures.sql')
        end

        test "synchronizes foreign keys after import" do
          Adva::Cnet::Importer::Product.new(:limit => 5, :order => :ext_product_id).run # TODO replace with our own local fixtures?
          Adva::Cnet::Importer::Attribute.new(:limit => 5, :order => :ext_value_id).run
          Adva::Cnet::Finalizer::Attribute.new.run

          values = Attributes::Value.all
          assert !values.empty?

          values.each do |value|
            assert value.attributable.is_a?(::Cnet::Product), "expected #{value.inspect} #attributable to be a Cnet::Product, but is #{value.attributable.class}"
          end
        end
      end
    end
  end
end