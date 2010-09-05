require 'reference_tracking'

# TODO somehow move to adva-cache

module Adva
  module References
    class << self
      def setup
        if defined?(ReferenceTracking)
          ActionController::Base.send(:include, ReferenceTracking::ActionController::ActMacro)
        else
          ActionController::Base.send(:include, Stubs)
        end
      end
    end
    
    module Stubs
      def tracks(*); end
      def purges(*); end
    end
  end
end

Adva::References.setup