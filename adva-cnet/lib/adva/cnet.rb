require 'adva'
require 'globalize'

module Adva
  class Cnet < ::Rails::Engine
    autoload :Downloader, 'adva/cnet/downloader'
    autoload :Extractor,  'adva/cnet/extractor'
    autoload :Importer,   'adva/cnet/importer'
    autoload :Logger,     'adva/cnet/logger'
    autoload :Origin,     'adva/cnet/origin'

    include Adva::Engine

    class << self
      def normalize_path(path)
        path.to_s.include?('/') ? path : root.join("db/cnet/#{path}")
      end
    end
  end
end