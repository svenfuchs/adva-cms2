module Adva
  class Static
    module Import
      class Directory
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
              params
            end
          end

          def path
            controller.polymorphic_path(controller.resources)
          end

          protected

            def controller
              @controller ||= init_controller(controller_name.constantize.new)
            end

            def init_controller(controller)
              controller.request = ActionDispatch::TestRequest.new

              symbols = controller.send(:symbols_for_association_chain).map { |name| :"#{name}_id" }
              symbols << :id unless record.new_record?
              controller.params = symbols.inject({}) do |params, name|
                # umm. admin blog routes use :blog_id, but Post has a section_id
                params.merge(name => attributes[section_ids.include?(name) ? :section_id : name].to_s)
              end

              controller
            end

            def section_ids
              @section_ids ||= Section.types.map { |type| :"#{type.underscore}_id" }
            end

            def controller_name
              "Admin::#{model_name.pluralize}Controller"
            end

            def model_name
              record.class.name
            end
        end
      end
    end
  end
end