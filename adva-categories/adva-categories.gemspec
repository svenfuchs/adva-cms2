# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'adva_categories/version'

Gem::Specification.new do |s|
  s.name         = "adva-categories"
  s.version      = AdvaCategories::VERSION
  s.authors      = ["Ingo Weiss", "Sven Fuchs"]
  s.email        = "nobody@adva-cms.org"
  s.homepage     = "http://github.com/svenfuchs/adva-cms2"
  s.summary      = "Categories engine for adva-cms2"
  s.description  = "Categories engine for adva-cms2."

  s.files        = Dir['{app,config,lib,public}/**/*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'adva-core'
  # s.add_dependency 'has_many_polymorphs'
end
