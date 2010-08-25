Adva::Registry.set :redirect, {
  'cart_items#destroy'         => lambda { |responder| [:cart] },
  'cart_addresses#create'      => lambda { |responder| [:edit, :cart, :payment_method] },
  'cart_payment_method#update' => lambda { |responder| [:new,  :cart, :confirmation] }
}