require 'thor'
require 'thor/group'
require 'patches/thor/core_ext/hash'
require 'patches/thor/group/symbolized_options'

module Adva
  module Tasks
    class Static
      class Setup < Thor::Group
        namespace 'adva:static:setup'
        desc 'Setup a static version of your site'
        class_option :target, :required => false

        def export
          require 'config/environment'
          Adva::Static::Setup.new(symbolized_options).run
        end
      end
      
      class Import < Thor::Group
        namespace 'adva:static:import'
        desc 'Import adva site'
        class_option :source, :required => false

        def import
          require 'config/environment'
          # require 'adva/static/import/directory'
          source = symbolized_options[:source] || 'import'
          Adva::Static::Import::Directory.new(source).import_all!
        end
      end

      class Export < Thor::Group
        namespace 'adva:static:export'
        desc 'Export a static version of your site'
        class_option :target, :required => false

        def export
          require 'config/environment'
          Adva::Static::Export.new(Rails.application, symbolized_options).run
        end
      end
    end
  end
end