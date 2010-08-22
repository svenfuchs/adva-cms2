require 'action_controller/metal/exceptions'

module Adva
  module Importers
    class Directory
      autoload :Blog,     'adva/importers/directory/blog'
      autoload :Model,    'adva/importers/directory/model'
      autoload :Page,     'adva/importers/directory/page'
      autoload :Path,     'adva/importers/directory/path'
      autoload :Post,     'adva/importers/directory/post'
      autoload :Runner,   'adva/importers/directory/runner'
      autoload :Section,  'adva/importers/directory/section'
      autoload :Site,     'adva/importers/directory/site'

      attr_reader :root, :routes

      def initialize(root, options = {})
        @root = Path.new(File.expand_path(root))
        @routes = options[:routes] || Rails.application.routes
      end

      def import!
        Site.new(root).import!
      end

      def sync!(path)
        path = normalize_path(path)
        params = recognize_path(path, env(::Site.first))
        const_from_params(params).new(path).sync!(params)
      rescue ActionController::RoutingError => e
        puts "can't sync #{path} because: #{e.message}"
      end

      protected

        def recognize_path(path, env)
          path = "/#{path.local.to_s}"
          routes.recognize_path(path == '/index' ? '/' : path, env)
        end

        def env(site)
          { 'SERVER_NAME' => site.host }
        end

        def normalize_path(path)
          Path.new(root.join(path.to_s.gsub(/^#{root.to_s}\//, '')), root)
        end

        def const_from_params(params)
          name = params[:controller].split('/').last.gsub('_controller', '')
          name = name.singularize.camelize
          Directory.const_get(name)
        end
    end
  end
end