Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :blogs do
        resources :posts
      end
    end
  end

  constraints :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ do
    match 'blogs/:id(/:year(/:month(/:day)))',      :to => 'blogs#show', :as => :blog
    match 'blogs/:blog_id/:year/:month/:day/:slug', :to => 'posts#show', :as => :blog_post
  end

  match 'blogs/:blog_id/*permalink', :to => "posts#internal", :as => :blog_post
end
