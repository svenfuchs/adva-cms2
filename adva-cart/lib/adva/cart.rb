require 'adva/engine'

module Adva
  class Cart < ::Rails::Engine
    include Adva::Engine
    
    DELIVERY_METHODS = ['UPS Priority']
    PAYMENT_METHODS  = ['Prepaid', 'Paypal']
  end
end