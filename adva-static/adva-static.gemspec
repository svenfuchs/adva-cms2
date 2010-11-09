# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'adva_static/version'

Gem::Specification.new do |s|
  s.name         = "adva-static"
  s.version      = AdvaStatic::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "nobody@adva-cms.org"
  s.homepage     = "http://github.com/svenfuchs/adva-cms2"
  s.summary      = "Static engine for adva-cms2"
  s.description  = "Static engine for adva-cms2"

  s.files        = Dir['{app,config,lib,public}/**/*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  
  s.add_dependency 'adva-core'
  s.add_dependency 'nokogiri'
  s.add_dependency 'rack-cache'
  s.add_dependency 'watchr'
end
