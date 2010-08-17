require 'action_controller/metal/exceptions'

module Adva
  module Importers
    class Directory
      autoload :Blog,     'adva/importers/directory/blog'
      autoload :Loadable, 'adva/importers/directory/loadable'
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
    
      def synchronize!(files = nil)
        Site.new(root).synchronize!
      end
    
      def sync_file(site, file)
        params = recognize_path(file.local_path.to_s, env(site))
        type = params[:controller].split('/').last.gsub('_controller', '').camelize
        Directory.const_get(type).new(file, params).synchronize!
      rescue ActionController::RoutingError
      end
      
      def recognize_path(path, env)
        routes.recognize_path(path, env)
      end
      
      def env(site)
        { 'SERVER_NAME' => site.host }
      end
    end
  end
end