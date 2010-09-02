require File.expand_path('../../test_helper', __FILE__)

module Tests
  module Cnet
    class ExtractorTest < Test::Unit::TestCase
      attr_reader :origin, :import

      def setup
        Adva.out = $stdout
        @origin  = Adva::Cnet::Connections.origin
        @import  = Adva::Cnet::Connections.import
        super
      end
      
      def teardown
        import.clear!
        super
      end

      test "extracting products from origin to import" do
        product = Adva::Cnet::Extractor::Product.new(import, 'products')
        product.run
        assert_equal origin.count('cds_prod'), import.count('products')
      end
    end
  end
end