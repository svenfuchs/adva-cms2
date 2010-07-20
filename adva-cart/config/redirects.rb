require 'adva/registry'

Adva::Registry.set :redirect, {
  'cart_items#destroy' => lambda { |responder| [:cart] }
}