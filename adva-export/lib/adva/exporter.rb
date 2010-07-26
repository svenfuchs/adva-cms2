require 'nokogiri'
require 'uri'

module Adva
  class Exporter
    class Queue < Array
      def concat(paths)
        paths.reject! { |path| seen.include?(path) }
        seen.concat(paths)
        seen.uniq!
      exit if seen.size > 1
        super
      end
      
      def seen
        @seen ||= []
      end
    end
    
    attr_reader :target, :queue
    
    def initialize(target, options = {})
      @target = Pathname.new(target)
      @queue  = Queue.new
    end
    
    def export
      require 'config/environment' unless Rails.application
      queue << '/'
      crawl
    end
    
    def crawl
      queue.concat(process(queue.shift)) until queue.empty?
    end
    
    def process(path)
      puts "processing #{path.inspect}"
      status, headers, response = get(path)
      body = normalize_body(response)
      
      if redirect?(status)
        [headers['Location']]
      else
        store.write(path, body)
        html?(path) ? urls_from(body) : []
      end
    end
    
    def get(path)
      Rails.application.call(env_for(path))
    end
    
    def redirect?(status)
      status == 301
    end
    
    def env_for(path)
      Rack::MockRequest.env_for(path)
    end
    
    def normalize_path(path)
      path.sub!(%r(^(http.?://[^/]*)), '')
      path.sub!(%r(^/|\.html$), '')
      path.sub!('?', '\?')
      html?(path) ? "#{path}.html" : path
    end
    
    def normalize_body(response)
      case response
      when ActionDispatch::Response
        response.body
      when Rack::File
        File.read(response.path)
      else
        response.join
      end
    end
    
    def urls_from(body)
      dom  = Nokogiri::HTML(body)
      urls = []
      # urls = node_attributes(dom, '//script[@src]', 'src')
      # urls += node_attributes(dom, '//link[@rel="stylesheet"]', 'href')
      urls += node_attributes(dom, '//a[@href]', 'href')
      urls.reject! { |url| url.blank? || url[0, 1] == '#' }
      urls.map! { |url| strip_query(url) }
      urls
    end
    
    def strip_query(url)
      uri = URI.parse(url)
      uri.query = nil
      uri.to_s
    end
    
    def node_attributes(dom, xpath, name)
      dom.xpath(xpath).map { |node| node.attributes[name].to_s }
    end
  end
end