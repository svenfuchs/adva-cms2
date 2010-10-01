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
            # FIXME this is way to greedy. should check which resources actually have changes
            resources.reject { |r| !r.respond_to?(:new_record?) }
          end
      end
    end
  end
end
