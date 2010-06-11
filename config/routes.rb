Rails.application.routes.draw do
  # match '/users/sign_in',  :to => 'admin/session#new',     :as => 'new_user_session'
  # match '/users/sign_in',  :to => 'admin/session#create',  :as => 'user_session', :via => :post
  # match '/users/sign_out', :to => 'admin/session#destroy', :as => 'new_user_session'
  
  devise_for :users, :controllers => { 
    :sessions => 'admin/session', :registrations => 'admin/registrations'
  }

  namespace :admin do
    resources :sites do
      resources :sections do
        resource :article
      end
    end
  end
  resources :sections,      :only => [:index, :show] # TODO remove index, gotta fix resource_awareness
  resources :installations, :only => [:new, :create]

  root :to => redirect(lambda { Site.first ? "/sections/#{Site.first.sections.first.id}" : '/installations/new' })
end