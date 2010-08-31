require 'adva/registry'

Adva::Registry.set :redirect, {
  'admin/assets#create' => lambda { |responder| responder.resources[0..-2].push(Asset) },
  'admin/assets#update' => lambda { |responder| responder.resources[0..-2].push(Asset) }
}