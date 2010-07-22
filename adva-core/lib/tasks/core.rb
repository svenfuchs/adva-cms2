require 'rake'
require 'thor'
require 'thor/group'
# require 'rails/generators'
require 'rails/engine'
require 'adva/core'

# thor adva:generate:engine blog

module Adva
  class Install < Thor::Group
    include Thor::Actions

    desc "install adva engines"
    source_root Adva::Core.root

    def perform
      copy_migrations
    end

    protected

      def copy_migrations
        Adva.engines.each do |engine|
          engine.copy_migrations.each do |path|
            say_status 'copy migration', File.basename(path)
          end
        end
      end
  end

  module Generate
    class Engine < Thor::Group
      include Thor::Actions

      desc "create an adva engine"
      argument :name
      source_root File.expand_path('../templates', __FILE__)

      def perform
        empty_directory "adva-#{name}"
        template        "gemspec.erb", "adva-#{name}/adva-#{name}.gemspec"
        template        'Gemfile.erb', "adva-#{name}/Gemfile"

        empty_directory "adva-#{name}/app"
        empty_directory "adva-#{name}/app/controllers"
        empty_directory "adva-#{name}/app/models"
        empty_directory "adva-#{name}/app/views"

        empty_directory "adva-#{name}/config"
        empty_directory "adva-#{name}/config/locales"
        template        'en.yml.erb', "adva-#{name}/config/locales/en.yml"
        template        'redirects.rb.erb', "adva-#{name}/config/redirects.rb"
        template        'routes.rb.erb', "adva-#{name}/config/routes.rb"

        empty_directory "adva-#{name}/db/migrate"
        template        'migration.rb.erb', "adva-#{name}/db/migrate/#{migration_timestamp}_adva_#{name}_create_tables.rb"

        empty_directory "adva-#{name}/lib/adva"
        create_file     "adva-#{name}/lib/adva-#{name}.rb", "require 'adva/#{name}'"
        template        'engine.rb.erb', "adva-#{name}/lib/adva/#{name}.rb"

        empty_directory "adva-#{name}/test"
      end

      protected

        def migration_timestamp
          Time.now.strftime('%Y%m%d%H%M%S')
        end

        def table_name
          name.tableize
        end

        def class_name
          name.classify
        end
    end
  end
end

namespace :adva do
  desc 'Install adva'
  task :install do
    Adva::Install.new.perform
  end
end