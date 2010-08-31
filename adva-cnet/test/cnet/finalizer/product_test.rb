require File.expand_path('../../../test_helper', __FILE__)

module Tests
  module Cnet
    module Finalizer
      class ProductTest < Test::Unit::TestCase
        include CnetTestHelper

        def setup
          super
          import.load('import.fixtures.sql')

          create_product(%w(100329 100372 100724 100732 100733))
          create_cnet_category(%w(CA CG))
          create_cnet_manufacturer(%w(F00058 F00027 F00046))
        end

        test "synchronizes foreign keys after import" do
          Adva::Cnet::Importer::Product.new(:limit => 5, :order => :ext_product_id).run # TODO replace with our own local fixtures?
          Adva::Cnet::Finalizer::Product.new.run

          products = ::Cnet::Product.all
          assert !products.empty?

          key_names = %w(product_id category_id manufacturer_id)
          products.each { |product| key_names.each { |name| assert_not_nil product.send(name), "expected #{product.inspect} #{name} not to be nil" } }
        end
      end
    end
  end
end