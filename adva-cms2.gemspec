# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'adva_cms2/version'

Gem::Specification.new do |s|
  s.name         = "adva-cms2"
  s.version      = AdvaCms2::VERSION
  s.authors      = ["Sven Fuchs", "Ingo Weiss", "Matthias Viehweger", "Johannes Strampe", "Raphaela Wrede", "Chris Fl\303\266\303\237"]
  s.email        = "svenfuchs@adva-business.com"
  s.homepage     = "http://github.com/svenfuchs/adva-cms2"
  s.summary      = "The cutting edge CMS framework"
  s.description  = "The cutting edge CMS framework"

  s.files        = `git ls-files app lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency('adva-core',       s.version)
  s.add_dependency('adva-blog',       s.version)
  s.add_dependency('adva-cache',      s.version)
  s.add_dependency('adva-categories', s.version)
  s.add_dependency('adva-static',     s.version)
  s.add_dependency('adva-user',       s.version)
  s.add_dependency('adva-markup',     s.version)
end
