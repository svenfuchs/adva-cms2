Adva::Registry.set :redirect, {
  'admin/pages#show'      => lambda { |responder| responder.resources.unshift(:edit) },
  'admin/pages#update'    => lambda { |responder| [:edit, *responder.resources] },
  'admin/pages#destroy'   => lambda { |responder| [*(responder.resources[0..-2] << :sections)] },

  'installations#create'  => lambda { |responder| '/' },
  'articles#show'         => lambda { |responder| responder.resource.section }
}