require File.expand_path('../test_helper', __FILE__)

module AdvaBlogTests
  class PostTest < Test::Unit::TestCase
    attr_reader :blog, :post_1, :post_2, :post_3

    def setup
      @blog = Factory(:blog)
      @post_1 = Factory(:post, :title => 'post 1', :published_at => DateTime.new(2010, 10, 10))
      @post_2 = Factory(:post, :title => 'post 2', :published_at => DateTime.new(2010, 10, 11))
      @post_3 = Factory(:post, :title => 'post 3', :published_at => DateTime.new(2010, 10, 12))
    end

    test 'previous returns the previous post' do
      assert_equal post_2, post_3.previous
      assert_equal post_1, post_2.previous
    end

    test 'next returns the next post' do
      assert_equal post_2, post_1.next
      assert_equal post_3, post_2.next
    end
  end
end

