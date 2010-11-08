Adva::Registry.set :redirect, {
  # TODO fix routes to map admin/sites/:site_id/blogs/:blog_id to admin/posts#index (instead of admin/blogs#show)
  'admin/blogs#show'    => lambda { |c| c.index_path(:posts) },
  'admin/blogs#create'  => lambda { |c| c.index_path(:posts) },
  'admin/blogs#update'  => lambda { |c| c.edit_url },

  'admin/posts#create'  => lambda { |c| c.edit_url },
  'admin/posts#update'  => lambda { |c| c.edit_url },
  'admin/posts#destroy' => lambda { |c| c.index_url }
}
