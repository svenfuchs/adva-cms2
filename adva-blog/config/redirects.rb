require 'adva/registry'

Adva::Registry.set :redirect, {
  'admin/blogs#update'    => lambda { |responder| [:edit, *responder.resources] },
  'admin/posts#create'    => lambda { |responder| [:edit, *responder.resources] },
  'admin/posts#update'    => lambda { |responder| [:edit, *responder.resources] }
}