require 'adva'

require 'rack/cache'
require 'rack/cache/purge'
require 'rack/cache/tags'

module Adva
  class Cache < ::Rails::Engine
    autoload :Responder, 'adva/cache/responder'

    include Adva::Engine

    # TODO add config vars to specify rack-cache storage uris
    config.app_middleware.insert_after 'Rails::Rack::Logger', ::Rack::Cache
    config.app_middleware.insert_after 'Rack::Cache', ::Rack::Cache::Purge
    config.app_middleware.insert_after 'Rack::Cache::Purge', ::Rack::Cache::Tags
  end
end

Adva::Responder.send(:include, Adva::Cache::Responder::Purge)
