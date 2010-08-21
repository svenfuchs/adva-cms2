require 'adva'
require 'globalize'

module Adva
  class Cnet < ::Rails::Engine
    autoload :Downloader, 'adva/cnet/downloader'
    autoload :Logger,     'adva/cnet/logger'
    autoload :Origin,     'adva/cnet/origin'

    include Adva::Engine
  end
end