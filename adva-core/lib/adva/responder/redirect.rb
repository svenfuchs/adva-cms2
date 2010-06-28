module Adva
  class Responder
    module Redirect
      def to_html
        return_to_redirect || responder_redirect || super
      end

      def return_to_redirect
        redirect_to(params[:return_to]) if params[:return_to] && !has_errors?
      end

      def responder_redirect # TODO extract to registry
        return if has_errors?

        section_types = Section.types.map { |type| type.underscore.pluralize }
        case controller_action_path
        when %r(admin/(#{section_types.join('|') })#update),
             %r(admin/articles#(create|update)),
             %r(admin/posts#(create|update)) # belongs to adva-blog
          redirect_to([:edit, *resources])
        end
      end

      def controller_action_path
        "#{controller_path}##{params[:action]}"
      end
    end
  end
end