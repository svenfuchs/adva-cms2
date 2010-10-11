module Adva
  class Cache
    module Responder
      module Purge
        delegate :purge,  :to => :controller
        delegate :purge?, :to => :'controller.class'

        def to_html
          super.tap { purge(purge_resources) if purge?(params[:action]) }
        end

        protected

          def purge_resources
            resource.respond_to?(:persisted?) ? [resource] : []
          end
      end
    end
  end
end
