require 'action_dispatch/routing/mapper'
require 'action_dispatch/routing/route_set'

module ActionDispatch
  module Routing
    class RouteSet
      def recognize_path(path, environment = {})
        method = (environment[:method] || "GET").to_s.upcase
        path = Rack::Mount::Utils.normalize_path(path)

        begin

          # TODO submit a rails patch

          # env = Rack::MockRequest.env_for(path, {:method => method})
          env = Rack::MockRequest.env_for(path, {:method => method}).merge(environment)
        rescue URI::InvalidURIError => e
          raise ActionController::RoutingError, e.message
        end

        req = Rack::Request.new(env)
        @set.recognize(req) do |route, matches, params|
          params.each do |key, value|
            if value.is_a?(String)
              value = value.dup.force_encoding(Encoding::BINARY) if value.encoding_aware?
              params[key] = URI.unescape(value)
            end
          end

          dispatcher = route.app
          dispatcher = dispatcher.app while dispatcher.is_a?(Mapper::Constraints)

          if dispatcher.is_a?(Dispatcher) && dispatcher.controller(params, false)
            dispatcher.prepare_params!(params)
            return params
          end
        end

        raise ActionController::RoutingError, "No route matches #{path.inspect}"
      end
    end
  end
end
