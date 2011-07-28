require 'adva'
require 'rack/server'

module Adva
  class Static
    module Server
      PURGE_HEADER = 'rack-cache.purge'
      STORE_HEADER = 'rack-static.store'

      autoload :Request, 'adva/static/server/request'
      autoload :Export,  'adva/static/server/export'
      autoload :Static,  'adva/static/server/static'
      autoload :Watch,   'adva/static/server/watch'

      class << self
        def start(options = {})
          require 'config/environment.rb'

          Rails::Application.configure do
            ActionController::Base.allow_forgery_protection = false
          end

          app = ::Rack::Builder.new {
            use Adva::Static::Server::Watch
            use Adva::Static::Server::Export
            use Adva::Static::Server::Static, File.expand_path(options[:root])
            run Rails.application
          }.to_app

          server = ::Rack::Server.new(:environment => options[:environment], :Port => options[:port])
          server.instance_variable_set(:@app, app) # TODO remove this once we can use rack-1.3.0
          server.start
        end
      end
    end
  end
end

