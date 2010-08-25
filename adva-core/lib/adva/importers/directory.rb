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
        sync(path).save!
      end

      def sync(path)
        params = recognize_path(path)
        recognize_file(path).sync(params)
      rescue ActionController::RoutingError => e
        puts "can't sync #{path} because: #{e.message}"
      end
      
      def recognize_file(path)
        params = recognize_path(path)
        path   = normalize_path(path)
        const_from_params(params).new(path)
      end

      def recognize_path(path)
        routes.recognize_path(normalize_url(path), env)
      end

      protected
      
        def site
          @site ||= ::Site.first # FIXME
        end

        def env
          { 'SERVER_NAME' => site.host }
        end

        def normalize_path(path)
          Path.new(root.join(path.to_s.gsub(/^#{root.to_s}\//, '')), root) # TODO ???
        end

        def normalize_url(path)
          path = Path.new(path).local
          path == site.sections.root.read_attribute(:path) ? '/' : "/#{path}"
        end

        def const_from_params(params)
          name = params[:controller].split('/').last.gsub('_controller', '')
          name = name.singularize.camelize
          Directory.const_get(name)
        end
    end
  end
end