Dir.chdir('..') until File.exists?('config/environment.rb')

require 'config/environment.rb'

use Adva::Static::Rack::Watch
use Adva::Static::Rack::Export
use Adva::Static::Rack::Static, ::File.expand_path('../export', __FILE__)

puts 'listening.'
run Rails.application
