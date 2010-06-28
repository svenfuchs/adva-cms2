Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :sections do
        resources :article
      end
    end
  end
  resources :sections, :only => [:index, :show] do # TODO remove index, gotta fix resource_awareness
    resources :article
  end
  resources :installations, :only => [:new, :create]

  root :to => redirect(lambda { Site.first ? "/sections/#{Site.first.sections.first.id}" : '/installations/new' })
end