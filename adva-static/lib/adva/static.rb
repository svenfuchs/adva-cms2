require 'adva/core'

module Adva
  class Static < ::Rails::Engine
    autoload :Export, 'adva/static/export'
    autoload :Import, 'adva/static/import'
    autoload :Setup,  'adva/static/setup'
    autoload :Server, 'adva/static/server'

    include Adva::Engine
  end
end
