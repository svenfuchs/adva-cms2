require File.expand_path('../../test_helper', __FILE__)

module Tests
  module Cnet
    class LoggerTest < Test::Unit::TestCase
      attr_reader :logger, :log
      
      def setup
        @log = StringIO.new
        Adva::Cnet::Logger.io = log
        @logger = Adva::Cnet::Logger.new
        super
      end

      def teardown
        Adva::Cnet::Logger.io = nil
        super
      end

      test "logs to info" do
        logger.info('foo')
        assert_equal 'foo', log.string.strip
      end
    end
  end
end

