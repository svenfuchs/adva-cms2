require File.expand_path('../../test_helper', __FILE__)

require 'core_ext/ruby/module/include_anonymous'

module AdvaCoreTests
  class IncludeAnonymousTest < Test::Unit::TestCase
    def teardown
      [:A, :B].each do |name|
        self.class.send(:remove_const, name) rescue nil
      end
    end

    test 'anonymous include on a class' do
      class A
        include { def foo; 'foo' end }
      end
      assert_equal 'foo', A.new.foo
    end

    test 'anonymous include on a module' do
      module A
        include { def foo; 'foo' end }
      end
      class B
        include A
      end
      assert_equal 'foo', B.new.foo
    end

    test 'multiple anonymous modules included into a module' do
      module A
        include { def foo; 'foo' end }
      end
      A.module_eval do
        include { def foo; "#{super}-foo" end }
      end
      class B
        include A
      end
      assert_equal 'foo-foo', B.new.foo
    end
  end
end
