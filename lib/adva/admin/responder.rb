require 'action_controller/metal/responder'

module Adva
  module Admin
    class Responder < ActionController::Responder
      def to_html
        super
      end
    end
  end
end