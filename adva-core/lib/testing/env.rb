ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'bundler/setup'
Bundler.require

name = "#{File.basename(Dir.pwd)}-test"
app = Adva::Generators::App.new(name, :target => '/tmp', :migrate => true)
app.invoke

require 'cucumber/rails/world'
require 'cucumber/web/tableish'
require 'test/unit/assertions'
require 'action_dispatch/testing/assertions'
require 'factory_girl'
require Adva::Core.root.join('lib/core_ext/rails/active_record/skip_callbacks')

Adva::Testing.load_factories
Adva::Testing.load_cucumber_support
Adva::Testing.load_assertions
Adva::Testing.load_helpers

Capybara.default_selector = :css
Capybara.default_wait_time = 5

# Fix undefined method `add_assertion' for nil:NilClass for all assertions
# https://github.com/aslakhellesoy/cucumber-rails/issues/97
if RUBY_VERSION =~ /1.8/
  require 'test/unit/testresult'
  Test::Unit.run = true
end

#ActionController::Base.allow_rescue = false
#Cucumber::Rails::World.use_transactional_fixtures = true
Rails.backtrace_cleaner.remove_silencers!

World(GlobalHelpers)
Adva.out = StringIO.new('')

