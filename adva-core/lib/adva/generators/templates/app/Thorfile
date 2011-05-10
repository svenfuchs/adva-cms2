require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require(:default)

$0 = 'thor'

Adva.engines.each { |engine| engine.new.load_tasks }
