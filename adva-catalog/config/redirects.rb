Adva::Registry.set :redirect, {
  'admin/catalogs#update' => lambda { |responder| [:edit, *responder.resources] },
  'admin/products#index'  => lambda { |responder| responder.resources[0..-2]    },
  'admin/products#create' => lambda { |responder| [:edit, *responder.resources] },
  'admin/products#update' => lambda { |responder| [:edit, *responder.resources] }
}