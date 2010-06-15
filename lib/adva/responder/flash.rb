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
        key = controller.controller_path.split('/')
        key << controller.action_name
        key << (has_errors? ? 'failure' : 'success')
        msg = I18n.t(key.join('.'))#, :resource => resource.class.human_name)
      end
    end
  end
end