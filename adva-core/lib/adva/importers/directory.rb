require 'action_controller/metal/exceptions'

module Adva
  module Importers
    class Directory
      autoload :Import,   'adva/importers/directory/import'
      autoload :Models,   'adva/importers/directory/models'
      autoload :Path,     'adva/importers/directory/path'
      autoload :Request,  'adva/importers/directory/request'

      attr_reader :root, :routes

      def initialize(root, options = {})
        @root = Path.new(File.expand_path(root))
        @routes = options[:routes] || Rails.application.routes
      end

      def import!
        Models::Site.new(root).import!
      end

      def sync!(path)
        Import.new(root, path, :routes => routes).sync!
      end
    end
  end
end