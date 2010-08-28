module Adva
  module Importers
    class Directory
      class Request
        delegate :record, :model_name, :to => :import
        attr_reader :import

        def initialize(import)
          @import = import
        end

        def path            
          controller.params = import.params.except(:controller, :action)
          symbols = controller.send(:symbols_for_association_chain).map { |name| :"#{name}_id" }
          symbols.each { |name| controller.params[name] = record.send(name).to_s }
          controller.polymorphic_path(controller.resources)
        end

        def params
          params = { model_name.to_sym => import.model.attributes }
          # params.key?('id') ? params.merge('_method' => 'put') : params
          record.new_record? ? params : params.merge('_method' => 'put')
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