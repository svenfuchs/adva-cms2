require 'adva/routing_filters/categories'

Rails.application.routes.draw do
  filter :categories

  namespace :admin do
    resources :sites do
      resources :blogs do
        resources :categories
      end
    end
  end
end
