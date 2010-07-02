require 'adva/registry'

Adva::Registry.set :redirect, {
  'admin/blogs#update' => lambda { |responder| [:edit, *responder.resources] },
  'admin/posts#index'  => lambda { |responder| responder.resources[0..-2]    },
  'admin/posts#create' => lambda { |responder| [:edit, *responder.resources] },
  'admin/posts#update' => lambda { |responder| [:edit, *responder.resources] }
}