# TODO make sure this can be called multiple times
#
module Adva
  class Markup
    module ActiveRecord
      module ActMacro
        def filters(*attributes)
          class_inheritable_accessor :filtered_attributes
          class_inheritable_accessor :read_filtered_attributes

          self.filtered_attributes = attributes
          self.read_filtered_attributes = false

          before_save :filter_attributes!
          include InstanceMethods
          include attribute_readers_module
        end

        def attribute_readers_module
          Module.new.tap do |readers|
            filtered_attributes.each do |name|
              readers.module_eval <<-rb
                def #{name}; read_filtered_attributes ? send(:#{name}_html) : super; end
              rb
            end
          end
        end
      end

      module InstanceMethods
        def filter_attributes!
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
