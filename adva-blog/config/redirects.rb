Adva::Registry.set :redirect, {
  'admin/blogs#update' => lambda { |r| r.controller.edit_url        },
  'admin/posts#index'  => lambda { |r| r.controller.parent_show_url },
  'admin/posts#create' => lambda { |r| r.controller.edit_url        },
  'admin/posts#update' => lambda { |r| r.controller.edit_url        }
}