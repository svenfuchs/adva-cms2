# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'adva_core/version'

Gem::Specification.new do |s|
  s.name         = "adva-core"
  s.version      = AdvaCore::VERSION
  s.authors      = ["Sven Fuchs", "Ingo Weiss", "Raphaela Wrede", "Matthias Viehweger", "Niklas Hofer", "Chris Floess", "Johannes Strampe"]
  s.email        = "nobody@adva-cms.org"
  s.homepage     = "http://github.com/svenfuchs/adva-cms2"
  s.summary      = "Core engine for adva-cms2"
  s.description  = "Core engine for adva-cms2"

  s.files        = Dir['{app,config,lib,public}/**/*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'rails', '3.0.9'
  s.add_dependency 'rake', '0.9.2'
  s.add_dependency 'i18n', '0.5.0'
  s.add_dependency 'activesupport-slices', '0.0.2'
  s.add_dependency 'gem-patching', '0.0.3'
  s.add_dependency 'routing-filter', '0.2.0'
  s.add_dependency 'inherited_resources', '1.2.2'
  s.add_dependency 'inherited_resources_helpers', '0.0.15'
  s.add_dependency 'minimal', '0.0.26'
  s.add_dependency 'simple_form', '~> 1.5.2'
  s.add_dependency 'simple_slugs', '0.0.8'
  s.add_dependency 'simple_table', '0.0.18'
  s.add_dependency 'simple_nested_set', '~> 0.1.8'
  s.add_dependency 'kronn-has_many_polymorphs', '3.0.2'
  s.add_dependency 'i18n-missing_translations', '0.0.1'
  s.add_dependency 'silence_log_tailer', '0.0.1'

  s.add_development_dependency 'sqlite3', '1.3.4'
end
