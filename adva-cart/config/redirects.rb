require 'adva/registry'

Adva::Registry.set :redirect, {
  'cart_items#destroy'    => lambda { |responder| [:cart] },
  'cart_addresses#create' => lambda { |responder| [:edit, :cart, :payment] }
}