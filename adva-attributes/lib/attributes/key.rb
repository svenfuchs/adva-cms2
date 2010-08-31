module Attributes
  class Key < ActiveRecord::Base
    set_table_name 'attributes_keys'

    acts_as_nested_set

    has_many :values, :class_name => 'Attributes::Value'

    translates :name

    accepts_nested_attributes_for :translations

    def group?
      !leaf?
    end

    # validates :classified_object_id, :presence => true
    # validates_uniqueness_of :classified_object_id, :scope => :attribute_key_id
  end
end
