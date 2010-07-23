Rails.application.routes.draw do
  resource :cart, :controller => 'cart', :only => [:show] do
    resources :items, :controller => 'cart_items', :only => [:create, :update, :destroy]
    resource :addresses, :controller => 'cart_addresses'
    resource :payment, :controller => 'cart_payment'
  end
end