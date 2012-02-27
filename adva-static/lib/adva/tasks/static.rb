require 'thor'
require 'thor/group'
require 'patches/thor/core_ext/hash'
require 'patches/thor/group/symbolized_options'

module Adva
  module Tasks
    class Static
      def self.load_environment
        $: << '.'
        require 'config/environment'
      end

      class Setup < Thor::Group
        namespace 'adva:static:setup'
        desc 'Setup a static version of your site'
        class_option :source, :required => false, :banner => 'source directory (defaults to import)'
        class_option :target, :required => false, :banner => 'source directory (defaults to export)'
        class_option :host,   :required => false, :banner => 'hostname of your site (defaults to example.org)'
        class_option :title,  :required => false, :banner => 'title of your site (defaults to the hostname)'
        class_option :remote, :required => false, :banner => 'github repository url (defaults to none)'

        def export
          Static.load_environment
          Adva::Static::Setup.new(symbolized_options).run
        end
      end

      class Import < Thor::Group
        namespace 'adva:static:import'
        desc 'Import a site from a directory'
        class_option :source, :required => false

        def import
          Static.load_environment
          Adva::Static::Import.new(symbolized_options).run
        end
      end

      class Export < Thor::Group
        namespace 'adva:static:export'
        desc 'Export a static version of a site'
        class_option :target, :required => false
        class_option :config, :required => false

        def export
          Static.load_environment
          Adva::Static::Export.new(Rails.application, symbolized_options).run
        end
      end

      class Update < Thor::Group
        namespace 'adva:static:update'
        desc 'Import and export a static version of a site'
        class_option :source, :required => false
        class_option :target, :required => false
        class_option :config, :required => false

        def export
          Static.load_environment
          Adva::Static::Import.new(symbolized_options).run
          Adva::Static::Export.new(Rails.application, symbolized_options).run
        end
      end

      class Server < Thor::Group
        namespace 'adva:static:server'
        desc 'Start the adva:static server and watcher'
        class_option :root, :required => false, :default => 'export'
        class_option :env,  :required => false, :default => 'development'
        class_option :port, :required => false, :default => '9292'

        def server
          Adva::Static::Server.start(symbolized_options)
        end
      end
    end
  end
end
