Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :sections
    end
  end
end