require 'nokogiri'
require 'uri'

module Adva
  class Static
    class Exporter
      attr_reader :app, :target, :queue, :store

      DEFAULT_OPTIONS = {
        :target => '/tmp/export'
      }

      def initialize(app, options = {})
        options = options.reverse_merge!(DEFAULT_OPTIONS)

        @app   = app
        @store = Static::Store.new(options[:target])
        @queue = Static::Queue.new
      end

      def run
        queue << Path.new('/')
        process(queue.shift) until queue.empty?
      end
      
      protected

        def process(path)
          page = get(path)
          store.write(path, page.body)
          enqueue_urls(page) if path.html?
        end

        def get(path)
          response = app.call(env_for(path))
          response = follow_redirects(response)
          Page.new(path, response[2])
        end

        def follow_redirects(response)
          response = app.call(env_for(response[1]['Location'])) while redirect?(response[0])
          response
        end

        def redirect?(status)
          status == 301
        end

        def env_for(path)
          Rack::MockRequest.env_for(path)
        end

        def enqueue_urls(page)
          queue.push(page.urls.reject { |path| store.exists?(path) })
        end
    end
  end
end