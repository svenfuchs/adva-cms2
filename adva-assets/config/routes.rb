Rails.application.routes.draw do
  namespace :admin do
    resources :asset_assignments
    resources :sites do
      resources :assets
    end
  end

  match 'assets/:id',                        :to => 'assets#show', :as => :asset
  #match 'catalogs/:catalog_id/products/:slug', :to => 'products#show', :as => :catalog_product
end