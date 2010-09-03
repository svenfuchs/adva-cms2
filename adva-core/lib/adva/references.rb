require 'reference_tracking'

module Adva
  module References
    class << self
      def setup
        if config.track_references
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
