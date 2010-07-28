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
        if !has_errors? && target = Registry.get(:redirect, controller_action_path)
          redirect_to(target.respond_to?(:call) ? target.call(self) : target)
        end
      end

      def controller_action_path
        "#{controller_path}##{params[:action]}"
      end
    end
  end
end