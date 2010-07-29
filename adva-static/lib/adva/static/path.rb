require 'uri'

module Adva
  class Static
    class Path < String
      def initialize(path)
        path = URI.parse(path.to_s).path
        path = "/#{path}" unless path[0, 1] == '/'
        path = path[0..-2] if path[-1, 1] == '/'
        super(path)
      end
      
      def filename
        @filename ||= (html? ? html : self)[1..-1]
      end
      
      def extname
        @extname ||= File.extname(self)
      end
    
      def html?
        extname.blank? || extname == '.html'
      end
      
      def html
        "#{self.gsub(extname, '')}.html"
      end
    end
  end
end