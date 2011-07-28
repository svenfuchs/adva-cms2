# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'adva_blog/version'

Gem::Specification.new do |s|
  s.name         = "adva-blog"
  s.version      = AdvaBlog::VERSION
  s.authors      = ["Sven Fuchs", "Ingo Weiss", "Raphaela Wrede", "Matthias Viehweger", "Niklas Hofer", "Chris Floess", "Johannes Strampe"]
  s.email        = "nobody@adva-cms.org"
  s.homepage     = "http://github.com/svenfuchs/adva-cms2"
  s.summary      = "Blog engine for adva-cms2"
  s.description  = "Blog engine for adva-cms2."

  s.files        = Dir['{app,config,lib,public}/**/*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'adva-core'
  s.add_dependency 'truncate_html'
end
