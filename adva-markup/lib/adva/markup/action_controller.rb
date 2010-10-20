module Adva
  class Markup
    module ActionController
      module ActMacro
        def filtered_attributes(*models)
          options = models.extract_options!
          options[:models] = models.map(&:to_s).map(&:camelize)
          options[:only]   = Array(options[:only]).map(&:to_sym)
          options[:except] = Array(options[:except]).map(&:to_sym)

          class_inheritable_accessor :filtered_attribute_options
          self.filtered_attribute_options = options

          include InstanceMethods
        end
      end

      module InstanceMethods
        def render(*args)
          options  = filtered_attribute_options
          excluded = options[:except].include?(params[:action].to_sym)
          included = options[:only].empty? || options[:only].include?(params[:action].to_sym)

          !excluded && included ? with_filtered_attributes { super } : super
        end

        def with_filtered_attributes
          models = filtered_attribute_options[:models].map(&:constantize)
          models.each { |model| model.filter_attributes = true }
          yield.tap do
            models.each { |model| model.filter_attributes = false }
          end
        end
      end
    end
  end
end

