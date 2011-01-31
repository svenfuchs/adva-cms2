require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'test_declarative'
require 'database_cleaner'
require 'factory_girl'
require 'ruby-debug'
require 'mocha'
require 'fakefs/safe'
require 'stringio'

ENV['RAILS_ENV'] = 'test'

Bundler.require(:default)

class ApplicationController < ActionController::Base ; end

Adva::Testing.setup(:log => '/tmp/adva-cms_test.log')
Dir[File.expand_path('../test_helpers/*.rb', __FILE__)].each { |file| require file }

# gawd, devise ...
Devise.setup do |config|
  require 'devise/orm/active_record'
  config.encryptor = :bcrypt
end

class Test::Unit::TestCase
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
