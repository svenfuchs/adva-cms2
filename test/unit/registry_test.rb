require File.expand_path('../../test_helper', __FILE__)

require 'adva/registry'

class Adva::Registry
  @@old_instance = nil
    
  class << self
    def backup!
      @@old_instance = defined?(@@instance) ? @@instance.dup : Adva::Registry.new
    end

    def restore!
      @@instance = @@old_instance
    end
  end
end

class RegistryTest < Test::Unit::TestCase
  def setup
    super
    Adva::Registry.backup!
    @registry = Adva::Registry.instance
    registry.clear
  end

  def teardown
    super
    Adva::Registry.restore!
  end
  
  attr_reader :registry
  
  # set

  test '#set sets stuff' do
    registry.set(:foo, :bar)
    assert_equal({ :foo => :bar }, registry)
  end

  test '#set sets stuff to nested keys' do
    registry.set(:foo, :bar, :baz, :buz)
    assert_equal({ :foo => { :bar => { :baz => :buz } } }, registry)
  end

  test '#set recursively turns passed hashes into registries' do
    registry.set(:foo, { :bar => { :baz => :buz } })
    assert registry.get(:foo).get(:bar).instance_of?(Adva::Registry)
  end
  
  test '#set merges given Hashes with an existing Registry' do
    registry.set(:foo, { :bar => :baz })
    registry.set(:foo, { :baz => :buz })
    assert_equal({ :bar => :baz, :baz => :buz }, registry.get(:foo))
  end
  
  # get

  test '#get gets stuff from nested keys' do
    registry.set(:foo, :bar, :baz, :buz)
    assert_equal({ :baz => :buz }, registry.get(:foo, :bar))
  end

  test '#get returns nil if an intermediary key is missing' do
    registry.set(:foo, :bar, :baz, :buz)
    assert_nil registry.get(:foo, :missing)
  end
  
  # alias
  
  test '#[] and #[]= works' do
    registry[:test] = 'test-alias'
    assert_equal 'test-alias', registry[:test]
  end
  
  test '#[]= supports nested keys' do
    registry[:test1][:test2] = 'key'
    assert_equal({ :test2 => 'key' }, registry[:test1])
    assert_equal 'key', registry[:test1][:test2]
  end
  
  # clear

  test '#clear clears registry' do
    registry.set(:foo, :bar, :baz, :buz)
    assert_equal({ :baz => :buz }, registry.get(:foo, :bar))
    
    registry.clear
    assert_nil registry.get(:foo, :bar)
    assert registry.empty?
  end

  test '#clear returns nil if an intermediary key is missing' do
    registry.set(:foo, :bar, :baz, :buz)
    assert_nil registry.get(:foo, :missing)
  end
end
