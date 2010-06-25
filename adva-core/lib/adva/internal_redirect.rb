module Adva
  module InternalRedirect
    def internal_redirect_to(target, params = nil)
      action, controller = target.split('#').reverse
      controller ||= controller_path

      params ||= self.params
      params.merge!(:controller => controller, :action => action)
      params = yield(params) if block_given?

      rack_endpoint = "#{controller}_controller".classify.constantize.action(action)
      env['action_dispatch.request.parameters'] = params
      rack_endpoint.call(env)
    end
  end
end