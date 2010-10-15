require 'inherited_resources'

Gem.patching('inherited_resources', '1.1.2') do
  InheritedResources::Actions.module_eval do
    module Actions
      def index(options={}, &block)
        respond_with(*(with_chain(resource_class) << options), &block)
      end
      alias :index! :index
    end
  end

  InheritedResources::BaseHelpers.module_eval do
    def collection
      get_collection_ivar || begin
        collection = end_of_association_chain
        collection = collection.find(:all) unless collection.respond_to?(:each)
        set_collection_ivar(collection)
      end
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

