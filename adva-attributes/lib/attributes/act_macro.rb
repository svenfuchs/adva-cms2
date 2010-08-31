module Attributes
  module ActMacro
    def has_many_attributes
      return if has_many_attributes?

      include InstanceMethods

      has_many :attribute_values, :class_name => 'Attributes::Value', :as => :attributable
      accepts_nested_attributes_for :attribute_values, :allow_destroy => :true, :reject_if => lambda { |attrs| attrs[:key_id].blank? }
    end

    def has_many_attributes?
      included_modules.include?(InstanceMethods)
    end
  end
end