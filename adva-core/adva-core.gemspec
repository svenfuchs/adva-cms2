# encoding: utf-8

Gem::Specification.new do |s|
  s.name         = "adva-core"
  s.version      = '0.0.1'
  s.authors      = ["Ingo Weiss", "Sven Fuchs"]
  s.email        = "nobody@adva-cms.org"
  s.homepage     = "http://github.com/svenfuchs/adva-cms2"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files        = Dir['{app,config,lib,public}/**/*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'rails', '3.0.0'
  s.add_dependency 'gem_patching', '0.0.2'
  s.add_dependency 'routing-filter', '0.2.0'
  s.add_dependency 'inherited_resources', '1.1.2'
  s.add_dependency 'inherited_resources_helpers', '0.0.14'
  s.add_dependency 'minimal', '0.0.22'
  s.add_dependency 'simple_form', '1.2.2'
  s.add_dependency 'simple_slugs', '0.0.7'
  s.add_dependency 'simple_table', '0.0.10'
  s.add_dependency 'simple_nested_set', '0.0.18'
  s.add_dependency 'kronn-has_many_polymorphs', '3.0.2'
  s.add_dependency 'silence_log_tailer', '0.0.1'
end
