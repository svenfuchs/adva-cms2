module Adva
  class Markup
    module ActiveRecord
      module ActMacro
        def filters(*attributes)
          class_inheritable_accessor :filtered_attributes
          self.filtered_attributes = attributes

          before_save :filter_attributes

          include InstanceMethods
        end
      end

      module InstanceMethods
        def filter_attributes
          filtered_attributes.each do |name|
            value = self.send(name)
            value = Adva::Markup.apply(filter, value) if respond_to?(:filter) && filter
            write_attribute(:"#{name}_html", value)
          end
        end
      end
    end
  end
end
