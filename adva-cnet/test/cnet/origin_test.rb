require File.expand_path('../../test_helper', __FILE__)

require 'adva/cnet/origin'

module Tests
  module Cnet
    class OriginTest < Test::Unit::TestCase
      
      def setup
        Adva::Cnet::Origin::Schema.load!
        super
      end
      
      test "load data to origin database" do
        Adva::Cnet::Origin::Source.load!(CNET_FIXTURES_PATH)
      end
    end
  end
end