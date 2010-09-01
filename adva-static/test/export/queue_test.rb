require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class QueueTest < Test::Unit::TestCase
    attr_reader :queue

    def setup
      @queue = Adva::Static::Export::Queue.new
    end

    test "logs elements it has seen" do
      assert !queue.seen?(1)
      queue.push(1)
      assert queue.seen?(1)
    end

    test "won't add elements that were seen before" do
      queue.push(1)
      assert queue.include?(1)

      queue.shift
      queue.push(1)
      assert !queue.include?(1)
    end
  end
end