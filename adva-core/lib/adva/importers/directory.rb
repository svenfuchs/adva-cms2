require 'action_controller/metal/exceptions'

module Adva
  module Importers
    class Directory
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

      def initialize(root)
        @root = Path.new(File.expand_path(root))
      end

      def import_all!
        Adva.out.puts "importing from #{root}"

        Account.all.each(&:destroy)
        Models::Site.new(root).updated_record.save!
      end

      def import!(path)
        importer_for(path).updated_record.save!
      end

      def request_for(path)
        importer = importer_for(path)
        Request.new(importer.record, importer.attributes)
      end

      protected

        def importer_for(path)
          path = absolutize(path)
          types = [Models::Site, Models::Post, Models::Section]
          types.each { |type| importer = type.build(path).first and return importer }
        end

        def absolutize(path)
          Path.new(root.join(path.to_s.gsub(/^(#{root.to_s})?\/?/, '')), root)
        end
    end
  end
end