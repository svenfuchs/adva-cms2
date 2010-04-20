Rails.application.routes.draw do
  namespace :adva do
    namespace :admin do
      resources :sites do
        resources :sections
      end
    end
  end
end