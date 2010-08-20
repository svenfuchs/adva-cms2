require 'routing_filter'
require 'adva/routing_filters/section_root'
require 'adva/routing_filters/section_path'

Rails.application.routes.draw do
  filter :section_root, :section_path

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

  root :to => redirect('/installations/new') # should only match if no root section is present
end