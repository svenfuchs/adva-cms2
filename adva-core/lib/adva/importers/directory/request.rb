module Adva
  module Importers
    class Directory
      class Request
        delegate :record, :changes, :model_name, :to => :import
        attr_reader :import

        def initialize(import)
          @import = import
        end

        def url
          "#{path}?#{Rack::Utils.build_nested_query(model_name.to_sym => changes)}"
        end

        def path
          controller.params = params
          controller.polymorphic_path(controller.resources)
        end

        def params
          params = import.params.except(:controller, :action)
          symbols = controller.send(:symbols_for_association_chain).map { |name| :"#{name}_id" }
          symbols.inject(params) { |data, name| data.merge(name => record.send(name).to_s) }
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