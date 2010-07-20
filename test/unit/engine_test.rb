# require File.expand_path('../../test_helper', __FILE__)
# require 'action_pack'
# require 'action_controller'
# require 'action_mailer'
#
# class ApplicationController < ActionController::Base
# end
#
# class EnginesTest < Test::Unit::TestCase
#   attr_accessor :app
#
#   def setup
#     self.app = Class.new(Rails::Application)
#     app.paths.app.models(DIRS[:fixtures].join('models'))
#     app.config.cache_classes = false
#     app.initialize!
#   end
#
#   def teardown
#     # somehow unload Rails.application
#   end
#
#   test "Product should be autoloadable" do
#     assert defined?(Product)
#     ActiveSupport::Dependencies.clear
#     app.initialize!
#     assert defined?(Product)
#   end
# end