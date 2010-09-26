require 'adva'

module Adva
  class Static < ::Rails::Engine
    autoload :Export, 'adva/static/export'
    autoload :Import, 'adva/static/import'
    autoload :Watch,  'adva/static/watch'
    autoload :Rack,   'adva/static/rack'
    autoload :Setup,  'adva/static/setup'

    include Adva::Engine
  end
end
