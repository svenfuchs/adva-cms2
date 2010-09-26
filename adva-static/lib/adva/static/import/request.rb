module Adva
  class Static
    class Import
      class Request
        attr_reader :record, :attributes

        def initialize(record, attributes)
          @record = record
          @attributes = attributes
        end

        def params
          @params ||= begin
            params = { model_name.underscore.to_sym => attributes }
            params.merge!('_method' => 'put') unless record.new_record?
            stringify(params)
          end
        end

        def path
          controller.polymorphic_path(controller.resources)
        end

        protected

          def controller
            @controller ||= controller_name.constantize.new.tap do |controller|
              controller.request = ActionDispatch::TestRequest.new
              controller.params = params_for(controller)
            end
          end

          def section_ids
            @section_ids ||= Section.types.map { |type| :"#{type.underscore}_id" }
          end

          def model_name
            record.class.name
          end

          def controller_name
            "Admin::#{model_name.pluralize}Controller"
          end

          def params_for(controller)
            names = controller.send(:symbols_for_association_chain).dup
            names.map! { |name| :"#{name}_id" }
            names << :id unless record.new_record?

            names.inject(:action => record.new_record? ? :index : :show) do |params, name|
              # umm. admin blog routes use :blog_id, but Post has a section_id
              value = attributes[section_ids.include?(name) ? :section_id : name].to_s
              params.merge(name => value)
            end
          end

          def stringify(object)
            case object
            when Hash
              object.each { |key, value| object[key] = stringify(value) }
            when Array
              object.map! { |element| stringify(element) }
            else
              object.to_s
            end
          end
      end
    end
  end
end