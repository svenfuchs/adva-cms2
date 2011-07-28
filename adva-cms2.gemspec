$:.unshift File.expand_path('../adva-core/lib', __FILE__)
require 'adva_core/version'
version = AdvaCore::VERSION

Gem::Specification.new do |s|
  s.name         = "adva-cms2"
  s.version      = version
  s.authors      = ["Sven Fuchs", "Ingo Weiss", "Raphaela Wrede", "Matthias Viehweger", "Niklas Hofer", "Chris Floess", "Johannes Strampe"]
  s.email        = "nobody@adva-cms.org"
  s.homepage     = "http://github.com/svenfuchs/adva-cms2"
  s.summary      = "Cutting edge Rails 3 CMS framework"
  s.description  = "Cutting edge Rails 3 CMS framework."

  s.platform     = Gem::Platform::RUBY
  s.rubyforge_project = '[none]'

  s.add_dependency 'adva-core',       version
  s.add_dependency 'adva-blog',       version
  s.add_dependency 'adva-cache',      version
  s.add_dependency 'adva-categories', version
  s.add_dependency 'adva-markup',     version
  s.add_dependency 'adva-static',     version
  s.add_dependency 'adva-user',       version
end
