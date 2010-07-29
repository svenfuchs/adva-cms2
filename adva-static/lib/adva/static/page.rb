module Adva
  class Static
    class Page
      URL_ATTRIBUTES = {
        '//a[@href]' => 'href',
        '//script[@src]' => 'src',
        '//link[@rel="stylesheet"]' => 'href'
      }

      attr_reader :url, :response

      def initialize(url, response)
        @url      = Path.new(url)
        @response = response
      end

      def urls
        URL_ATTRIBUTES.inject([]) do |urls, (xpath, name)|
          urls += dom.xpath(xpath).map { |node| Path.new(node.attributes[name]) }
        end
      end
      
      def body
        @body ||= case response
        when ActionDispatch::Response
          response.body
        when Rack::File
          File.read(response.path)
        else
          response.to_s
        end
      end
      
      protected

        def dom
          @dom ||= Nokogiri::HTML(body)
        end
    end
  end
end