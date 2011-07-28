# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'adva_markup/version'

Gem::Specification.new do |s|
  s.name         = "adva-markup"
  s.version      = AdvaMarkup::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "nobody@adva-cms.org"
  s.homepage     = "http://github.com/svenfuchs/adva-cms2"
  s.summary      = "Markup engine for adva-cms2"
  s.description  = "Markup engine for adva-cms2."

  s.files        = Dir['{app,config,lib,public}/**/*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'adva-core'
  s.add_dependency 'rdiscount'
  s.add_dependency 'RedCloth'
end
