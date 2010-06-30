require 'adva/registry'

Adva::Registry.set :redirect, {
  # 'admin/catalogs#update' => lambda { |responder| [:edit, *responder.resources] },
  # 'admin/catalogs#create' => lambda { |responder| [:edit, *responder.resources] },
  'admin/catalogs#update' => lambda { |responder| [:edit, *responder.resources] }
}