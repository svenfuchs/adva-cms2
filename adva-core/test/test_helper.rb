require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'test_declarative'
require 'database_cleaner'
require 'ruby-debug'
require 'mocha'
require 'fakefs/safe'
require 'stringio'

Bundler.require(:default)

Adva.out = StringIO.new('')
TEST_LOG = '/tmp/adva-cms_test.log'
class ApplicationController < ActionController::Base ; end

Dir[File.expand_path('../test_{helpers/*,setup}.rb', __FILE__)].each do |helper|
  require helper
end

class Test::Unit::TestCase
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end