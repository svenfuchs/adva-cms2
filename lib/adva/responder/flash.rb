module Adva
  class Responder
    module Flash
      def to_html
        set_flash_message unless get?
        super
      end
      
      def set_flash_message
        controller.flash[(has_errors? ? :error : :notice)] = flash_message
      end
      
      def flash_message
        namespace = controller.controller_path.split('/')
        namespace << controller.action_name
        namespace << (has_errors? ? 'failure' : 'success')
        msg = I18n.t(namespace.join("."), :scope => :flash, :default => namespace.join('.'))#, :resource => resource.class.human_name)
      end
    end
  end
end