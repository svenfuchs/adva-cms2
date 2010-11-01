Adva::Registry.set :redirect, {
  # see comment in admin/blog_controller
  # 'admin/blogs#show'    => lambda { |c| c.index_path(:posts) },
  'admin/blogs#update'  => lambda { |c| c.edit_url },
  'admin/posts#create'  => lambda { |c| c.edit_url },
  'admin/posts#update'  => lambda { |c| c.edit_url },
  'admin/posts#destroy' => lambda { |c| c.show_parent_url }
}
