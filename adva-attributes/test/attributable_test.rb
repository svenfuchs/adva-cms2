require File.expand_path('../test_helper', __FILE__)

class AttributablesTest < ActiveSupport::TestCase
  include AttributesTestHelper
  
  test "unassigned_attribute_keys returns keys without value for this object" do
    type, size, color = create_keys(%w(type size color))

    first = Attributable.create!(:name => 'first', :attribute_values_attributes => [
      { :key_id => type.id,  :display_value => 'Storage' }
    ])

    assert_equal [size, color], first.unassigned_attribute_keys

    Attributable.create!(:name => 'another', :attribute_values_attributes => [
      { :key_id => type.id,  :display_value => 'Storage' },
      { :key_id => color.id,  :display_value => 'Green' },
      { :key_id => size.id,  :display_value => 'Big' }
    ])

    second = Attributable.create!(:name => 'second', :attribute_values_attributes => [
      { :key_id => size.id,  :display_value => 'Medium' }
    ])

    assert_equal [type, color], second.unassigned_attribute_keys
  end
end
