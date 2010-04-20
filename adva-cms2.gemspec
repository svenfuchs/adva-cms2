# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)
require 'adva/version'

Gem::Specification.new do |s|
  s.name         = "adva-cms2"
  s.version      = Adva::VERSION
  s.authors      = ["Ingo Weiss", "Sven Fuchs"]
  s.email        = "nobody@adva-cms.org"
  s.homepage     = "http://github.com/svenfuchs/adva-cms2"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files        = Dir['{app,config,lib}/**/*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  s.required_rubygems_version = '>= 1.3.6'
  
  s.add_dependency 'rails', '~> 3'
end
