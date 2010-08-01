Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :catalogs do
        resources :products
      end
    end
  end

  match 'catalogs/:id',               :to => 'catalogs#show', :as => :catalog
  match 'catalogs/:catalog_id/:slug', :to => 'products#show', :as => :catalog_product
end