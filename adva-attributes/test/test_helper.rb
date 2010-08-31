require File.expand_path('../../../adva-core/test/test_helper', __FILE__)
require 'adva-attributes'
require File.expand_path('../test_models', __FILE__)

module AttributesTestHelper
  def create_keys(*names)
    Array(names).flatten.map { |name| create_key(name) }
  end

  def create_key(name, attributes = {})
    Attributes::Key.create!(attributes.reverse_merge(:value_type => 'String', :locale => 'en', :name => name))
  end
end