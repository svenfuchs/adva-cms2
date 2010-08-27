begin
  require 'webrat'
rescue LoadError
end
# require 'webrat/core/logging'
require 'gem_patching'

Gem.patching('webrat', '0.7.1') do
  ActionController.send(:remove_const, :AbstractRequest)
end if defined?(Webrat)
