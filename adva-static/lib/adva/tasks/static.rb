require 'thor'
require 'thor/group'
require 'patches/thor/core_ext/hash'
require 'patches/thor/group/symbolized_options'

module Adva
  module Tasks
    class Static < Thor::Group
      namespace 'adva:export:static'
      desc 'Export a static version of your site'
      class_option :target, :required => false

      def export
        require 'config/environment'
        Adva::Static::Exporter.new(Rails.application, symbolized_options).run
      end
    end

    module Import
      module Directory
        class Import < Thor::Group
          namespace 'adva:import:directory'
          desc 'Import adva site'
          class_option :source, :required => false

          def import
            require 'config/environment'
            require 'adva/importers/directory'
            source = symbolized_options[:source] || 'import'
            Adva::Importers::Directory.new(source).import_all!
          end
        end
      end
    end
  end
end