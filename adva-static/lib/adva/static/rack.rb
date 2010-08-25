require 'adva'

module Adva
  class Static
    module Rack
      PURGE_HEADER = 'rack-cache.purge'

      autoload :Export, 'adva/static/rack/export'
      autoload :Watch,  'adva/static/rack/watch'
    end
  end
end
