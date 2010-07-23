# ENV["RAILS_ENV"] ||= "test"
# require 'rubygems'
# require 'bundler'
# require 'test/unit'
# require 'test_declarative'
# require 'database_cleaner'
# require 'ruby-debug'
# 
# Bundler.setup
# 
# require File.expand_path('../../../features/support/host_app', __FILE__)
# 
# options = {
#   :regenerate => !!ENV['REGENERATE_APP'],
#   :template   => File.expand_path('../../../features/fixtures/host_app_template.rb', __FILE__)
# }
# HostApp.new(File.expand_path('../../..', __FILE__), options) do
#   run 'rake adva:install --trace'
# end
# 
# DatabaseCleaner.strategy = :truncation
# 
# # require 'site'
# # require 'section'
# # require 'page'
# # require 'content'
# # require 'article'
# 
# class Test::Unit::TestCase
#   def teardown
#     DatabaseCleaner.clean
#   end
# end