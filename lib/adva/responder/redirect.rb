module Adva
  class Responder
    module Redirect
      def to_html
        return_to_redirect || responder_redirect || super
      end
      
      def return_to_redirect
        redirect_to(params[:return_to]) if params[:return_to] && !has_errors?
      end
      
      def responder_redirect
        case controller_action_path
        when 'admin/sections#create', 'admin/articles#update'
          redirect_to([:edit, *resources])
        end unless has_errors?
      end
      
      def controller_action_path
        "#{controller_path}##{params[:action]}"
      end
    end
  end
end