module Adva
  class Cache
    module Responder
      module Purge
        delegate :purge,  :to => :controller
        delegate :purge?, :to => :'controller.class'
        
        def to_html
          purge(controller.resources.reject { |r| !r.respond_to?(:new_record?) }) if purge?(params[:action])
          super
        end
      end
    end
  end
end
