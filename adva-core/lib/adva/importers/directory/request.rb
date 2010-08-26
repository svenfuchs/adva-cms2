module Adva
  module Importers
    class Directory
      class Request
        attr_reader :record
        
        def initialize(record, params)
          @record = record
          @params = params
        end
        
        def path
          controller.params = params
          path = controller.polymorphic_path(controller.resources)
          "#{path}?#{Rack::Utils.build_nested_query(params)}"
        end
      
        def params
          symbols = controller.send(:symbols_for_association_chain).map { |name| :"#{name}_id" }
          symbols.inject(@params) { |data, name| data.merge(name => record.send(name).to_s) }
        end

        def controller
          @controller ||= controller_name.constantize.new.tap do |controller|
            controller.request = ActionDispatch::TestRequest.new
          end
        end
      
        def controller_name
          "Admin::#{record.class.name.pluralize}Controller"
        end
      end
    end
  end
end