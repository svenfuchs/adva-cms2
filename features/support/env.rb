ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../host_app', __FILE__)
include HostApp

recreate_host_app         # generates host app with our template
load_host_app_environment # loads the host app's environment.rb

require 'cucumber/rails/world'
require 'cucumber/rails/active_record'

require 'webrat'
require 'webrat/core/matchers'

Webrat.configure do |config|
  config.mode = :rack
  config.open_error_files = false
end

class Cucumber::Rails::World 
  include Webrat::Methods 
  include Webrat::Matchers 
end 

ActionController::Base.allow_rescue = false
Cucumber::Rails::World.use_transactional_fixtures = true

Before do
  # Adva::Site.create!()
end


# # How to clean your database when transactions are turned off. See
# # http://github.com/bmabey/database_cleaner for more info.
# if defined?(ActiveRecord::Base)
#   begin
#     require 'database_cleaner'
#     DatabaseCleaner.strategy = :truncation
#   rescue LoadError => ignore_if_database_cleaner_not_present
#   end
# end
