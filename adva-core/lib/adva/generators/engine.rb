require 'rails/generators'

module Adva
  module Generators
    class Engine < Rails::Generators::Base
      source_root File.expand_path('../templates/engine', __FILE__)
      
      attr_reader :name
      
      def initialize(name, options = {})
        @name = name
        super()
      end
      
      def build
        empty_directory "adva-#{name}"
        template        "gemspec.erb", "adva-#{name}/adva-#{name}.gemspec"
        template        'Gemfile.erb', "adva-#{name}/Gemfile"

        empty_directory "adva-#{name}/app"
        empty_directory "adva-#{name}/app/controllers"
        empty_directory "adva-#{name}/app/models"
        empty_directory "adva-#{name}/app/views"

        empty_directory "adva-#{name}/config"
        empty_directory "adva-#{name}/config/locales"
        template        'en.yml.erb',  "adva-#{name}/config/locales/en.yml"
        template        'redirects.rb.erb', "adva-#{name}/config/redirects.rb"
        template        'routes.rb.erb', "adva-#{name}/config/routes.rb"

        empty_directory "adva-#{name}/db/migrate"
        template        'migration.rb.erb', "adva-#{name}/db/migrate/#{migration_timestamp}_adva_#{name}_create_tables.rb"

        empty_directory "adva-#{name}/lib/adva"
        create_file     "adva-#{name}/lib/adva-#{name}.rb", "require 'adva/#{name}'"
        template        'engine.rb.erb', "adva-#{name}/lib/adva/#{name}.rb"

        empty_directory "adva-#{name}/test"
        template        'all.rb', "adva-#{name}/test/all.rb"
        template        'test_helper.rb.erb', "adva-#{name}/test/test_helper.rb"
      end
      
      protected

        def migration_timestamp
          Time.now.strftime('%Y%m%d%H%M%S')
        end

        def table_name
          name.tableize
        end
        
        def class_name
          name.camelize
        end
    end
  end
end