require 'adva/registry'

Adva::Registry.set :redirect, {
  'admin/pages#show'      => lambda { |responder| responder.resources.unshift(:edit).push(responder.resource.article) },
  'admin/pages#update'    => lambda { |responder| [:edit, *responder.resources] },
  'admin/pages#destroy'   => lambda { |responder| [*(responder.resources[0..-2] << :sections)] },

  'admin/articles#index'  => lambda { |responder| responder.resources[0..-2] },
  'admin/articles#create' => lambda { |responder| [:edit, *responder.resources] },
  'admin/articles#update' => lambda { |responder| [:edit, *responder.resources] },

  'installations#create'  => lambda { |responder| '/' },
  'articles#show'         => lambda { |responder| responder.resource.section }
}