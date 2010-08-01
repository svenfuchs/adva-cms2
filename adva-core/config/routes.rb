Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :sections, :only => [:index, :new, :create]
      resources :pages do
        resource :article
      end
    end
  end
  
  match 'pages/:id',              :to => 'pages#show',    :as => :page
  match 'pages/:page_id/article', :to => 'articles#show', :as => :page_article

  resources :installations, :only => [:new, :create]

  root :to => redirect(lambda { Site.first ? "/pages/#{Site.first.sections.first.id}" : '/installations/new' })
end