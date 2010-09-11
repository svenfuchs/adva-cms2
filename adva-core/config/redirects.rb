Adva::Registry.set :redirect, {
  'installations#create'  => lambda { |r| '/'                          },
  'articles#show'         => lambda { |r| r.controller.parent_show_url },

  'admin/sites#update'    => lambda { |r| r.controller.edit_url        },
  'admin/pages#update'    => lambda { |r| r.controller.show_url        },
  'admin/pages#destroy'   => lambda { |r| r.controller.index_url       }
}