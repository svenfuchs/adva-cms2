Adva::Registry.set :redirect, {
  'installations#create'  => lambda { |c| c.installation_url(c.resource) },
  'articles#show'         => lambda { |c| c.show_parent_url },

  'admin/sites#update'    => lambda { |c| c.edit_url        },
  'admin/pages#update'    => lambda { |c| c.show_url        },
  'admin/pages#destroy'   => lambda { |c| c.index_url       }
}
