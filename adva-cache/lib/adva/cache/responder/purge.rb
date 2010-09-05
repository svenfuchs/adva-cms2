module Adva
  class Cache
    module Responder
      module Purge
        delegate :purges?, :purge?, :purge, :to => :controller
        
        def to_html
          purge(controller.resources.reject { |r| !r.respond_to?(:new_record?) }) if purge?(params[:action])
          super
        end
      end
    end
  end
end
