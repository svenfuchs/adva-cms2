require 'i18n/exceptions'

I18n.module_eval do
  I18n::ExceptionHandler.send :include, Module.new {
    def call(exception, locale, key, options)
      I18n.missing_translations.log(exception.keys) if I18n::MissingTranslationData === exception
      super
    end
  }

  class << self
    attr_writer :missing_translations

    def missing_translations
      @missing_translations ||= MemoryLogger.new
    end
  end

  class MemoryLogger < Hash
    def initialize
      at_exit { dump } if Rails.env.test?
    end

    def log(keys)
      log = self
      keys.each_with_index do |key, ix|
        key = key.to_s
        if ix < keys.size - 1
          log = log.key?(key) ? log[key] : (log[key] = {})
        else
          log[key] = key.to_s.titleize
        end
      end
    end

    def dump
      require 'yaml'
      puts YAML.dump(Hash[*to_a.flatten]) unless empty?
    end
  end
end
