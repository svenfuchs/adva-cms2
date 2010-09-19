require 'adva/registry'

Adva::Registry.set :redirect, {
  'admin/assets#create' => lambda { |c| c.index_url },
  'admin/assets#update' => lambda { |c| c.index_url }
}