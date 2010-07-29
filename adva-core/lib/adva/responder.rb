require 'responders'

module Adva
  class Responder < ActionController::Responder
    autoload :Redirect, 'adva/responder/redirect'

    include Adva::Responder::Redirect
    include Responders::FlashResponder
    include Responders::HttpCacheResponder

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
