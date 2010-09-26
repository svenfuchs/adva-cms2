require 'nokogiri'
require 'uri'
require 'benchmark'

module Adva
  class Static
    class Export
      autoload :Page,   'adva/static/export/page'
      autoload :Path,   'adva/static/export/path'
      autoload :Queue,  'adva/static/export/queue'
      autoload :Store,  'adva/static/export/store'

      attr_reader :app, :target, :queue, :store

      DEFAULT_OPTIONS = {
        :target => "#{Dir.pwd}/export"
      }

      def initialize(app, options = {})
        options = options.reverse_merge!(DEFAULT_OPTIONS)

        @app   = app
        @store = Store.new(options[:target])
        @queue = Queue.new

        queue.push(options[:queue] || Path.new('/'))

        FileUtils.rm_r(Dir["#{options[:target]}/*"]) rescue Errno::ENOENT
      end

      def run
        configure
        process(queue.shift) until queue.empty?
      end

      protected

        def process(path)
          if page = get(path)
            store.write(path, page.body)
            enqueue_urls(page) if path.html?
          end
        end

        def get(path)
          response = nil
          bench = Benchmark.measure do
            response = app.call(env_for(path))
            response = follow_redirects(response)
          end

          status = response[0]
          if status == 200
            Adva.out.puts "#{bench.total.to_s[0..3]}s: exporting #{path}"
            Page.new(path, response[2])
          else
            Adva.out.puts "can not export #{path} (status: #{status})"
          end
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
          ::Rack::MockRequest.env_for(path).merge('SERVER_NAME' => name,'SERVER_PORT' => port || '80')
        end

        def enqueue_urls(page)
          queue.push(page.urls.reject { |path| path.remote? || store.exists?(path) }.uniq)
        end

        def configure
          config = Path.new('config.ru')
          unless store.exists?(config)
            store.write(config, File.read(File.expand_path('../export/templates/config.ru', __FILE__)))
          end
        end
    end
  end
end