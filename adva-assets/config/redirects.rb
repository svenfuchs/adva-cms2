require 'adva/registry'

Adva::Registry.set :redirect, {
  'admin/assets#create' => lambda { |r| r.controller.index_url },
  'admin/assets#update' => lambda { |r| r.controller.index_url }
}