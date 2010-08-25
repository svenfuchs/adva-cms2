require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require(:default)

$0 = 'thor'

require 'action_controller' # TODO hu?
Adva.engines.each { |engine| engine.new.load_tasks }
