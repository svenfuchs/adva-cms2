require 'responders/flash_responder'

Responders::FlashResponder.class_eval do
  def flash_defaults_by_namespace(status)
    defaults = []
    slices   = controller.controller_path.split('/')

    while slices.size > 0
      defaults << :"flash.#{slices.fill(controller.controller_name, -1).join('.')}.#{controller.action_name}.#{status}"
      defaults << :"flash.#{slices.join('.')}.#{controller.action_name}.#{status}"
      slices.shift
    end

    defaults << :"flash.#{controller.action_name}.#{status}"
    defaults << :"flash.actions.#{controller.action_name}.#{status}"
    defaults.uniq << ""
  end
end
