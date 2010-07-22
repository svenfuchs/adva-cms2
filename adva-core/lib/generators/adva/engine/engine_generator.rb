require 'rails/generators'

# rails g adva:engine blog

module Adva
  class EngineGenerator < Rails::Generators::NamedBase
    class_option :install_custom_responder, :type => :boolean, :default => false
  
    def self.source_root
      @source_root ||= File.expand_path('../templates', __FILE__)
    end
  
    # def install_custom_responder
    #   return unless options[:install_custom_responder] or yes?('Install custom responder using the prosecco responder? (yes/no)')
    #   copy_file 'custom_responder.rb', 'lib/custom_responder.rb'
    #   inject_into_file 'app/controllers/application_controller.rb', :before => /\nend\Z/ do
    #     "\n\n  def self.responder\n    CustomResponder\n  end\n" 
    #   end
    # end
    # 
    # def install_migration
    #   # TODO: Use migration_template method instead which generated a timestamp
    #   copy_file "20091216161939_create_prosecco_tables.rb", "db/migrate/20091216161939_create_prosecco_tables.rb"
    # end
  
    def install_assets
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
      create_file "adva-#{name}/lib/adva-#{name}.rb", "require 'adva/#{name}'"
      template    'engine.rb.erb', "adva-#{name}/lib/adva/#{name}.rb"
      
      empty_directory "adva-#{name}/test"
    end
    
    def migration_timestamp
      Time.now.strftime('%Y%m%d%H%M%S')
    end
  end
end

# ~> -:1:in `require': no such file to load -- rails/generators (LoadError)
# ~> 	from -:1
