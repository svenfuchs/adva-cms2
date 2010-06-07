ENV["RAILS_ENV"] ||= "test"
require 'rubygems'
require 'bundler'
Bundler.setup

require File.expand_path('../host_app', __FILE__)

options = {
  :regenerate => !!ENV['REGENERATE_APP'], 
  :template   => File.expand_path('../host_app_template.rb', __FILE__)
}
HostApp.new(File.expand_path('../../..', __FILE__), options) do
  run 'rake adva:cms:install'
end

# for webrat 0.7.0 / rails 3.0.0.beta3 compat
ActionController.send(:remove_const, :AbstractRequest)

require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'webrat'
require 'webrat/core/matchers'
require 'test/unit/assertions'
require 'action_dispatch/testing/assertions'

Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

ActionController::Base.allow_rescue = false
Cucumber::Rails::World.use_transactional_fixtures = true

# class Cucumber::Rails::World
#   include Rack::Test::Methods
#   include Cucumber::Rails::World::Adapter
#   include Webrat::Methods
#   include Webrat::Matchers
#   include ActionDispatch::Assertions
# end

Before do
  @current_site = Site.create!(:name => 'adva-cms', :host => 'adva-cms.com', :title => "adva-cms")
end

Rails.backtrace_cleaner.remove_silencers!

# # How to clean your database when transactions are turned off. See
# # http://github.com/bmabey/database_cleaner for more info.
# if defined?(ActiveRecord::Base)
#   begin
#     require 'database_cleaner'
#     DatabaseCleaner.strategy = :truncation
#   rescue LoadError => ignore_if_database_cleaner_not_present
#   end
# end
