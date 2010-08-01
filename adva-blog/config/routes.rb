Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :blogs do
        resources :posts
      end
    end
  end

  match 'blogs/:id(/:year(/:month(/:day)))',      :to => 'blogs#show',     :as => :blog
  match 'blogs/:blog_id/:year/:month/:day/:slug', :to => 'posts#show'
  match 'blogs/:blog_id/*permalink',              :to => "posts#internal", :as => :blog_post
end