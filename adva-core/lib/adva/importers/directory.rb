require 'action_controller/metal/exceptions'

module Adva
  module Importers
    class Directory
      autoload :Import,   'adva/importers/directory/import'
      autoload :Path,     'adva/importers/directory/path'
      autoload :Request,  'adva/importers/directory/request'

      module Models
        autoload :Base,    'adva/importers/directory/models/base'
        autoload :Blog,    'adva/importers/directory/models/blog'
        autoload :Page,    'adva/importers/directory/models/page'
        autoload :Post,    'adva/importers/directory/models/post'
        autoload :Section, 'adva/importers/directory/models/section'
        autoload :Site,    'adva/importers/directory/models/site'
      end

      attr_reader :root, :routes

      def initialize(root, options = {})
        @root = Path.new(File.expand_path(root))
        @routes = options[:routes] || Rails.application.routes
      end

      def import!
        Models::Site.new(root).import!
      end

      def sync!(path)
        import(path).sync!
      end

      def import(path)
        Import.new(root, path, :routes => routes)
      end
    end
  end
end