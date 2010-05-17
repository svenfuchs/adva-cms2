Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :sections do
        resource :article
      end
    end
  end
end