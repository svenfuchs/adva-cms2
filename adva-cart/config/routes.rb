Rails.application.routes.draw do
  resource :cart, :controller => 'cart', :only => [:show] do
    resources :items, :controller => 'cart_items', :only => [:create, :update, :destroy]
  end
end