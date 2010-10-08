require File.expand_path('../test_helper', __FILE__)

ActiveRecord::Schema.define(:version => 1) do
  create_table 'has_option_test_foos', :force => true do |t|
    t.text :options
  end
end

require 'adva/active_record/has_options'

module AdvaCoreTests
  class HasOptionsTest < Test::Unit::TestCase
    class Foo < ActiveRecord::Base
      set_table_name 'has_option_test_foos'
      has_option :filter
    end

    class Bar < Foo
      has_option :check, :type => :boolean
      has_option :built, :type => :datetime
    end

    attr_reader :controller

    test 'option_type' do
      assert_equal :string, Foo.new.option_type(:filter)
      assert_equal :boolean, Bar.new.option_type(:check)
    end

    test 'option on base class' do
      model = Foo.create!(:filter => 'textile')
      assert_equal 'textile', model.reload.filter
    end

    test 'option on child class' do
      model = Bar.create!(:filter => 'textile')
      assert_equal 'textile', model.reload.filter
    end

    test 'option on child class, typecasting to boolean' do
      model = Bar.create!(:check => 1)
      assert_equal true, model.reload.check
    end

    test 'option on child class, typecasting to datetime' do
      foo = Bar.create!(:built => '2010-10-01')
      assert_equal 10, foo.reload.built.month
    end
  end
end

