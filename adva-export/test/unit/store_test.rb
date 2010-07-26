require File.expand_path('../../test_helper', __FILE__)
require 'adva/exporter'
require 'rubygems'

module AdvaExporter
  class StoreTest < Test::Unit::TestCase
    attr_reader :store
    
    def setup
      @store = Adva::Export::Store.new(File.expand_path('../../fixtures/store', __FILE__))
    end
    
    test "exists? finds an existing path" do
      assert store.exists?('/index.html')
    end
    
    test "exists? finds an existing path not missing a leading slash" do
      assert store.exists?('index.html')
    end
    
    test "exists? does not find a missing path" do
      assert !store.exists?('/missing.html')
    end
  end
end