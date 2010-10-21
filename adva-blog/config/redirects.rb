Adva::Registry.set :redirect, {
  'admin/blogs#update'  => lambda { |c| c.edit_url },
  'admin/posts#create'  => lambda { |c| c.edit_url },
  'admin/posts#update'  => lambda { |c| c.edit_url },
  'admin/posts#destroy' => lambda { |c| c.show_parent_url }
}
