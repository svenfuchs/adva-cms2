Rails.application.routes.draw do
  resource :cart, :controller => 'cart', :only => [:show, :update] do
    resources :items, :controller => 'cart_items', :only => [:create, :update, :destroy]
    resource :addresses, :controller => 'cart_addresses'
    resource :payment_method, :controller => 'cart_payment_method'
    resource :confirmation, :controller => 'cart_confirmation'
  end
end