require 'adva/registry'

Adva::Registry.set :redirect, {
  'admin/pages#update'    => lambda { |responder| [:edit, *responder.resources] },
  'admin/articles#create' => lambda { |responder| [:edit, *responder.resources] },
  'admin/articles#update' => lambda { |responder| [:edit, *responder.resources] }
}