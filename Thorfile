require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require(:default)

Adva.engines.each { |engine| engine.new.load_tasks }
