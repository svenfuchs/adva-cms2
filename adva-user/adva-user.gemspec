# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'adva_user/version'

Gem::Specification.new do |s|
  s.name         = "adva-user"
  s.version      = AdvaUser::VERSION
  s.authors      = ["Ingo Weiss", "Sven Fuchs"]
  s.email        = "nobody@adva-cms.org"
  s.homepage     = "http://github.com/svenfuchs/adva-cms2"
  s.summary      = "User engine for adva-cms2"
  s.description  = "User engine for adva-cms2"

  s.files        = Dir['{app,config,lib,public}/**/*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  
  s.add_dependency 'adva-core'
  s.add_dependency 'devise', '1.3.4'
end
