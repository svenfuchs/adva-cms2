# Common redirect responder. Redirects to a :return_to param if present or an
# entry in the Registry for the current controller/action (e.g. pages#update).

module Adva
  class Responder
    module Redirect
      def to_html
        return_to_redirect || registry_redirect || super
      end

      def return_to_redirect
        redirect_to(params[:return_to]) if !get? && params[:return_to] && !has_errors?
      end

      def registry_redirect
        if !has_errors? && target = current_redirect
          redirect_to(target)
        end
      end

      def current_redirect
        target = Registry.get(:redirect, controller_action_path)
        target.respond_to?(:call) ? target.call(controller) : target
      end

      def controller_action_path
        "#{controller_path}##{params[:action]}"
      end
    end
  end
end
