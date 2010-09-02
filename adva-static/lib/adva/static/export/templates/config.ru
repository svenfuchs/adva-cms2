Dir.chdir('..') until File.exists?('config/environment.rb')

require 'config/environment.rb'

Rails::Application.configure do
  ActionController::Base.allow_forgery_protection = false
end

use Adva::Static::Rack::Monitor
use Adva::Static::Rack::Export
use Adva::Static::Rack::Static, ::File.expand_path('../export', __FILE__)

puts 'listening.'
run Rails.application
