# TODO, needs to use the local Gemfile if we're in an app
ENV['BUNDLE_GEMFILE'] = File.expand_path('../../../../Gemfile', __FILE__)

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

Adva.engines.each { |engine| engine.new.load_tasks }

if task = Thor::Util.find_by_namespace("adva:#{ARGV.first}") 
  ARGV.shift
else
  task = Thor::Util.find_by_namespace("adva:app")
end

task.start