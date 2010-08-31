require File.expand_path('../test_helper', __FILE__)

# TODO
#
# - versioning
# - type casting

class AttributesTest < ActiveSupport::TestCase
  include AttributesTestHelper
  
  attr_reader :base_specs, :clock_rate, :cpu_type

  def setup
    @base_specs = create_key('technical specifications')
    @clock_rate = create_key('clock rate', :value_type => 'float', :parent_id => base_specs.id)
    @cpu_type   = create_key('cpu type', :value_type => 'string', :parent_id => base_specs.id)
    super
  end

  def attribute_values_attributes
    [
      { :key_id => clock_rate.id, :display_value => '2.7', :numeric_value => '2700', :unit => 'ghz' },
      { :key_id => cpu_type.id,   :display_value => 'amd sempron 140' }
    ]
  end

  # # TODO for matze
  # 
  #   ext_specs = create_key('extended specifications')
  #   general   = create_key('general',   :parent_id => ext_specs.id)
  #   misc      = create_key('misc',      :parent_id => ext_specs.id)
  #   type      = create_key('type',      :parent_id => general.id)
  #   color     = create_key('color',     :parent_id => general.id)
  #   cables    = create_key('cables',    :parent_id => misc.id)
  #   standards = create_key('standards', :parent_id => misc.id)
  # 
  #   assert_equal [base_specs.name, ext_specs.name], Attributes::Key.roots.map(&:name)
  #   assert_equal [general.name, misc.name],         ext_specs.children.map(&:name)
  #   assert_equal [type.name, color.name],           general.children.map(&:name)
  #   assert_equal [cables.name, standards.name],     misc.children.map(&:name)
  # 
  #   object.update_attributes!(:attribute_values_attributes => [
  #     { :key_id => type.id,      :display_value => 'storage' },
  #     { :key_id => color.id,     :display_value => 'black' },
  #     { :key_id => cables.id,    :display_value => '1 x usb cable, external' },
  #     { :key_id => standards.id, :display_value => 'ce' },
  #   ])
  #   assert_equal [base_specs, ext_specs, general, type, color, misc, cables, standards], object.specifications
  # end

  test "can create a new object with attribute_values (using :accepts_nested_attributes_for)" do
    object = Attributable.create!(:name => 'another name', :attribute_values_attributes => attribute_values_attributes).reload

    clock_rate = object.attribute_values.detect { |s| s.name == 'clock rate' }
    cpu_type   = object.attribute_values.detect { |s| s.name == 'cpu type' }

    assert_equal 'float',           clock_rate.value_type
    assert_equal 'clock rate',      clock_rate.name
    assert_equal 'ghz',             clock_rate.unit
    assert_equal '2.7',             clock_rate.display_value
    assert_equal 2700.0,            clock_rate.numeric_value

    assert_equal 'string',          cpu_type.value_type
    assert_equal 'cpu type',        cpu_type.name
    assert_equal nil,               cpu_type.unit
    assert_equal 'amd sempron 140', cpu_type.display_value
    assert_equal nil,               cpu_type.numeric_value
  end

  test "can update an existing object with attribute_values (using :accepts_nested_attributes_for)" do
    object = Attributable.create!(:name => 'name', :attribute_values_attributes => attribute_values_attributes)
    object.reload

    clock_rate_value = object.attribute_values.detect { |value| value.key_id == clock_rate.id }
    cpu_type_value   = object.attribute_values.detect { |value| value.key_id == cpu_type.id }

    updated_attributes = attribute_values_attributes

    updated_attributes.first.merge!(
      :id            => clock_rate_value.id,
      :key_id        => clock_rate.id,
      :numeric_value => '3000',
      :display_value => '3.0'
    )
    updated_attributes.second.merge!(
      :id     => cpu_type_value.id,
      :key_id => cpu_type.id,
      :display_value => 'amd sempron 240'
    )

    assert_difference "object.attribute_values.size", 0 do
      object.update_attributes(:name => 'name', :attribute_values_attributes => updated_attributes)
      object.reload

      clock_rate = object.attribute_values.detect { |s| s.name == 'clock rate' }
      cpu_type   = object.attribute_values.detect { |s| s.name == 'cpu type' }

      assert_equal 'float',           clock_rate.value_type
      assert_equal 'clock rate',      clock_rate.name
      assert_equal 3000.0,            clock_rate.numeric_value
      assert_equal 'ghz',             clock_rate.unit
      assert_equal '3.0',             clock_rate.display_value

      assert_equal 'string',          cpu_type.value_type
      assert_equal 'cpu type',        cpu_type.name
      assert_equal nil,               cpu_type.unit
      assert_equal 'amd sempron 240', cpu_type.display_value
      assert_equal nil,               cpu_type.numeric_value
    end
  end

  test "can delete attribute_values from an existing object" do
    object = Attributable.create!(:name => 'name', :attribute_values_attributes => attribute_values_attributes)
    object.reload

    assert_difference "object.attribute_values.size", -1 do
      deleted_attributes = [{ :id => object.attribute_values.first.id, :_destroy => '1' }]
      object.update_attributes(:attribute_values_attributes => deleted_attributes)
      object.reload
    end
  end

  test "assigned_attribute_keys" do
    object = Attributable.create!(:name => 'name', :attribute_values_attributes => attribute_values_attributes)
    assert_equal ['clock rate', 'cpu type'], object.assigned_attribute_keys.map(&:name)
  end

  test "unassigned_attribute_keys" do
    object = Attributable.create!(:name => 'name', :attribute_values_attributes => attribute_values_attributes)
    assert_equal [], object.unassigned_attribute_keys.map(&:name)
  end
end
