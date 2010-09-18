require File.expand_path('../../test_helper', __FILE__)

require 'core_ext/ruby/module/include_anonymous'

module AdvaCoreTests
  class IncludeAnonymousTest < Test::Unit::TestCase
    def teardown
      self.class.send(:remove_const, :A)
    end
    
    test 'anonymous include on a class' do
      class A
        include { def foo; 'foo' end }
      end
      assert_equal 'foo', A.new.foo
    end
  end
end