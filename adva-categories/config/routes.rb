require 'adva/routing_filters/categories'

Rails.application.routes.draw do
  filter :categories

  namespace :admin do
    resources :sites do
      resources :sections do
        resources :categories
      end
    end
  end
end
