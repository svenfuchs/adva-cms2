module Adva
  module Controller
    module InternalRedirect
      def internal_redirect_to(target, params = nil)
        action, controller = target.split('#').reverse
        controller ||= controller_path

        params ||= self.params
        params.merge!(:controller => controller, :action => action)
        params = yield(params) if block_given?

        rack_endpoint = "#{controller}_controller".classify.constantize.action(action)
        env['action_dispatch.request.parameters'] = params
        response = rack_endpoint.call(env)

        self.status, self.headers, self.response_body = response
        @_response.headers.replace(response[1])

        response
      end
    end
  end
end