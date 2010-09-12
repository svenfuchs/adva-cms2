require 'action_controller'

begin
  require 'reference_tracking'
rescue LoadError
end

module Adva
  module Controller
    module References
      module Stubs
        def self.included(base)
          base.class_eval do
            def self.tracks(*); end
            def self.purges(*); end
          end
        end
        def purge?(*); end
      end
      
      ActionController::Base.send(:include, Stubs) unless defined?(ReferenceTracking)
    end
  end
end

