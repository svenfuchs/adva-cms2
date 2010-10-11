# encoding: utf-8

# $: << File.expand_path('../lib', __FILE__)
# require 'adva/markup/version'

Gem::Specification.new do |s|
  s.name         = "adva-markup"
  s.version      = '0.0.1'
  s.authors      = ["Sven Fuchs"]
  s.email        = "nobody@adva-cms.org"
  s.homepage     = "http://github.com/svenfuchs/adva-cms2"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files        = Dir['{app,config,lib,public}/**/*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'adva-core'
  s.add_dependency 'rdiscount'
  s.add_dependency 'RedCloth'
end
