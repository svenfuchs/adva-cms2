require 'adva'

module Adva
  class Static < ::Rails::Engine
    include Adva::Engine

    autoload :Exporter, 'adva/static/exporter'
    autoload :Page,     'adva/static/page'
    autoload :Path,     'adva/static/path'
    autoload :Queue,    'adva/static/queue'
    autoload :Store,    'adva/static/store'
  end
end
