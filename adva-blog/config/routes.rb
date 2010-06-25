Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :sections do
        resources :posts
      end
    end
  end

  resources :sections, :only => [:index, :show] do # TODO remove index, gotta fix resource_awareness
    resources :posts
  end
end