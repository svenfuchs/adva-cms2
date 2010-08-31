require 'action_controller'
require 'responders'

module Adva
  class Responder < ActionController::Responder
    autoload :Redirect, 'adva/responder/redirect'

    module Base
      include Adva::Responder::Redirect
      include Responders::FlashResponder
      include Responders::HttpCacheResponder
    end
    include Base

    delegate :params, :controller_path, :resource, :resources, :to => :controller

    def action
      controller.params[:action]
    end
  end
end
