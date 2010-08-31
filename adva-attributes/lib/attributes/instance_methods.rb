module Attributes
  module InstanceMethods
    # Returns the complete tree of attribute keys and assigned values
    def specifications
      condition = "(lft <> rgt - 1) OR #{equals_attributable.to_sql}" # TODO extract nested set scope: e.g. branches_condition (lft <> rgt - 1)
      Key.includes(:values).select(:id).where(condition).with_translations.all
    end

    def assigned_attribute_keys
      Key.with_leaves.where(key_table[:id].in(assigned_values_key_ids)).all
    end

    def unassigned_attribute_keys
      Key.with_leaves.where(key_table[:id].not_in(assigned_values_key_ids)).all
    end

    def assigned_values_key_ids
      key_table.join(value_table).on(has_values.and(equals_attributable)).project(key_table[:id])
    end

    protected

      def has_values
        key_table[:id].eq(value_table[:key_id])
      end

      def equals_attributable
        equals_attributable_id.and(equals_attributable_type)
      end

      def equals_attributable_id
        value_table[:attributable_id].eq(self.id)
      end

      def equals_attributable_type
        value_table[:attributable_type].eq(self.class.name)
      end

      def key_table
        Key.arel_table
      end

      def value_table
        Value.arel_table
      end
  end
end
    