module Attributes
  class Value < ActiveRecord::Base
    set_table_name 'attributes_values'

    belongs_to :key, :class_name => 'Attributes::Key'
    belongs_to :attributable, :polymorphic => true

    translates :display_value, :unit

    accepts_nested_attributes_for :translations

    delegate :name, :value_type, :to => :key

    # validates :classified_object_id, :presence => true
    # validates_uniqueness_of :classified_object_id, :scope => :attribute_key_id
  end
end