require File.expand_path('../../test_helper', __FILE__)

require 'core_ext/rails/active_record/skip_callbacks'

module AdvaCoreTests
  module Testing
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Schema.define :version => 0 do
      create_table :skip_callbacks, :force => true do |t|
        t.string :name
      end
    end

    class SkipCallback < ActiveRecord::Base
      set_table_name 'skip_callbacks'
      before_create { |record| record.name = 'created' }
      before_update { |record| record.name = 'updated' }
    end
  
    class SkipCallbacksTest < Test::Unit::TestCase
      test "calls callbacks" do
        record = SkipCallback.create
        assert_equal 'created', record.name
        
        record.save
        assert_equal 'updated', record.name
      end

      test "skip_callbacks skips callbacks" do
        record = SkipCallback.skip_callbacks { SkipCallback.create! }
        assert_nil record.name
      end

      test "skip_callbacks skips, then calls a callback" do
        record = SkipCallback.skip_callbacks { SkipCallback.create! }
        record.save
        assert_equal 'updated', record.name
      end
      
      test "without_callbacks skips callbacks" do
        record = SkipCallback.without_callbacks.create!
        assert_nil record.name
      end
    end
  end
end


