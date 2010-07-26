require 'uri'

module Adva
  class Export
    class Path < String
      def initialize(path)
        path = URI.parse(path).path
        path = "/#{path}" unless path[0, 1] == '/'
        super(path)
      end
    
      def html?
        extname.blank? || extname == '.html'
      end
      
      def extname
        @extname ||= File.extname(self)
      end
      
      def filename
      end
    end
  end
end