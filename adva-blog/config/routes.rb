Rails.application.routes.draw do
  # overwrite admin/blog#show to point to admin/posts#index instead
  # can this be simplified? haven't had any luck putting it into the resource block
  get 'admin/sites/:site_id/blogs/:blog_id', :to => 'admin/posts#index', :as => 'admin_site_blog'

  namespace :admin do
    resources :sites do
      resources :blogs do
        resources :posts
      end
    end
  end

  constraints :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ do
    get 'blogs/:blog_id(/:year(/:month(/:day)))', :to => 'posts#index', :as => :blog
    get 'blogs/:blog_id/:year/:month/:day/:slug', :to => 'posts#show'
  end

  # this is just here so we get the named url helper and can use url_for([blog, post])
  # TODO [routes] how can we improve this? can we just make this a regular helper blog_post_path?
  get 'blogs/:blog_id/*permalink', :to => "posts#internal", :as => :blog_post
end
