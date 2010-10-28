Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :blogs do
        resources :posts
      end
    end
  end

  constraints :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ do
    match 'blogs/:blog_id(/:year(/:month(/:day)))', :to => 'posts#index', :as => :blog
    match 'blogs/:blog_id/:year/:month/:day/:slug', :to => 'posts#show'
  end

  # this is just here so we get the named url helper and can use url_for(blog, post)
  # TODO how can we improve this?
  match 'blogs/:blog_id/*permalink', :to => "posts#internal", :as => :blog_post
end
