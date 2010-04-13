Rails.application.routes.draw do
  namespace :admin do
    resources :sites
  end
end