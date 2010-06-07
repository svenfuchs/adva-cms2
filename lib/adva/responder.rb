require 'action_controller/metal/responder'

module Adva
  class Responder < ActionController::Responder
    include Adva::Responder::Flash
    include Adva::Responder::Redirect
    
    def params
      controller.params
    end
    
    def controller_path
      controller.controller_path
    end
    
    def action
      controller.params[:action]
    end
  end
end
