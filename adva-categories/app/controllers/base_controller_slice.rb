require_dependency 'base_controller'

module InheritedResources
  module Actions
    def index(options={}, &block)
      respond_with(*(with_chain(resource_class) << options), &block)
    end
    alias :index! :index
  end

  module BaseHelpers
    protected
      def collection
        get_collection_ivar || set_collection_ivar(end_of_association_chain)
      end

      def build_resource
        get_resource_ivar || begin
          resource = end_of_association_chain.send(method_for_build, params[resource_instance_name] || {})
          end_of_association_chain.delete(resource) if method_for_build == :build
          set_resource_ivar(resource)
        end
      end
  end
end

BaseController.class_eval do
  include do
    def collection
      collection = super
      params[:category_id] ? collection.categorized(params[:category_id]) : collection
    end
  end
end
