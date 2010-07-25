require 'adva/engine'

module Adva
  class Cart < ::Rails::Engine
    include Adva::Engine
    
    DELIVERY_METHODS = ['DHL Paket']
    PAYMENT_METHODS  = ['Prepaid', 'Paypal']
  end
end