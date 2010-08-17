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

        queue.push(options[:queue] || Path.new('/'))
      end

      def run
        process(queue.shift) until queue.empty?
        configure
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
          site = Site.first || raise('could not find any site') # TODO make this a cmd line arg or options
          name, port = site.host.split(':')
          Rack::MockRequest.env_for(path).merge('SERVER_NAME' => name,'SERVER_PORT' => port || '80')
        end

        def enqueue_urls(page)
          queue.push(page.urls.reject { |path| path.remote? || store.exists?(path) })
        end

        def configure
          store.write Path.new('config.ru'), <<-conf.split("\n").map(&:strip).join("\n")
            require 'rubygems'
            require 'action_controller'
            require 'action_dispatch'

            use ActionDispatch::Static, Dir.pwd
            run lambda { |env| [404, { 'Content-Type' => 'text/plain' }, '404'] }
          conf
        end
    end
  end
end