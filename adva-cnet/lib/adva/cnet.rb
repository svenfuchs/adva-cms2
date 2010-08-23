require 'adva'
require 'globalize'

module Adva
  class Cnet < ::Rails::Engine
    autoload :Downloader, 'adva/cnet/downloader'
    autoload :Logger,     'adva/cnet/logger'
    autoload :Origin,     'adva/cnet/origin'

    include Adva::Engine
    
    cattr_accessor :out
    self.out = $stdout

    class << self
      def say(string)
        out.puts(string)
      end
      
      def normalize_path(path)
        path.to_s.include?('/') ? path : root.join("db/cnet/#{path}")
      end
    end
  end
end