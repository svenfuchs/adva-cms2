begin
  require 'webrat'
rescue LoadError
end
# require 'webrat/core/logging'
require 'gem_patching'

Gem.patching('webrat', '0.7.1') do
  Webrat::Logging.class_eval do
    def logger
      case Webrat.configuration.mode
      when :rails
        defined?(Rails) ? Rails.logger : nil
      else
        super
      end
    end
  end
end if defined?(Webrat)