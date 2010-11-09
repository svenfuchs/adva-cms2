Adva::Registry.set :redirect, {
  'admin/blogs#create'  => lambda { |c| c.index_path(:posts) },
  'admin/blogs#update'  => lambda { |c| c.edit_url },

  'admin/posts#create'  => lambda { |c| c.edit_url },
  'admin/posts#update'  => lambda { |c| c.edit_url },
  'admin/posts#destroy' => lambda { |c| c.index_url }
}
