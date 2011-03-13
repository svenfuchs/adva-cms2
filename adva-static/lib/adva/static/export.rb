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

      attr_reader :app, :queue, :store, :options

      DEFAULT_OPTIONS = {
        :source => "#{Dir.pwd}/public",
        :target => "#{Dir.pwd}/export"
      }

      def initialize(app, options = {})
        options.reject! { |key, value| value.blank? }
        @options = options.reverse_merge!(DEFAULT_OPTIONS)

        @app   = app
        @store = Store.new(target)
        @queue = Queue.new

        roots = config[:roots] || %w(/)
        queue.push(*roots.map { |path| Path.new(path) })

        FileUtils.rm_r(Dir[target.join('*')])
      end

      def run
        configure
        copy_assets
        process(queue.shift) until queue.empty?
      end

      protected

        def source
          @source ||= Pathname.new(options[:source])
        end

        def target
          @target ||= Pathname.new(options[:target])
        end

        def copy_assets
          Dir[source.join('*')].each { |file| FileUtils.cp_r(file, target.join(file.gsub("#{source}/", ''))) }
        end

        def process(path)
          if page = get(path)
            store.write(path, page.body)
            enqueue_urls(page) if path.html?
          end
        end

        def get(path)
          result = nil
          bench = Benchmark.measure do
            result = app.call(env_for(path))
            result = follow_redirects(result)
          end

          status, headers, response = result
          if status == 200
            Adva.out.puts "#{bench.total.to_s[0..3]}s: exporting #{path}"
            Page.new(path, headers['X-Sendfile'] ? File.read(headers['X-Sendfile']) : response)
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
          site = Site.first || raise('could not find any site')
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

        def config
          YAML.load_file(options[:config] || Rails.root.join('config/static.yml')).symbolize_keys
        rescue
          {}
        end
    end
  end
end
