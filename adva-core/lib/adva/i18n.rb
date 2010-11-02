require 'i18n/exceptions'

I18n.module_eval do
  self.exception_handler = :log_missing_translations

  class << self
    attr_writer :logger

    def missing_translations
      @missing_translations ||= MemoryLogger.new
    end

    def log_missing_translations(exception, locale, key, options)
      missing_translations.log(exception.keys) if I18n::MissingTranslationData === exception
      default_exception_handler(exception, locale, key, options)
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

I18n::MissingTranslationData.class_eval do
  def keys
    options.each { |k, v| options[k] = v.inspect if v.is_a?(Proc) }
    keys = I18n.normalize_keys(locale, key, options[:scope])
    keys << 'no key' if keys.size < 2
    keys
  end
end
