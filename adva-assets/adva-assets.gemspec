# encoding: utf-8

# $: << File.expand_path('../lib', __FILE__)
# require 'adva/assets/version'

Gem::Specification.new do |s|
  s.name         = "adva-assets"
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
  
  s.add_dependency 'adva-core'
  s.add_dependency 'carrierwave-rails3'
  #s.add_dependency 'rmagick'
  s.add_dependency 'mini_magick'
  # s.add_dependency 'remotipart'

end