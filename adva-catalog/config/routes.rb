Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :sections do
        resources :products
      end
    end
  end

  resources :sections, :only => [:index, :show] do # TODO remove index, gotta fix resource_awareness
    resources :products
  end
end