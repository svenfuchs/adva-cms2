require 'yaml'
require 'fileutils'
require 'i18n'
require 'i18n/exceptions'

module I18n
  # extend the ExceptionHandler so it logs missing translations to I18n.missing_translations
  ExceptionHandler.send :include, Module.new {
    def call(exception, locale, key, options)
      I18n.missing_translations.log(exception.keys) if MissingTranslationData === exception
      super
    end
  }

  class << self
    attr_writer :missing_translations

    def missing_translations
      @missing_translations ||= MissingTranslationsLog.new
    end
  end

  class MissingTranslationsLog < Hash
    attr_reader :app, :filename

    def initialize(app = nil, filename = nil)
      @app = app
      @filename = filename || guess_filename
    end

    def call(*args)
      I18n.missing_translations = self
      clear
      read
      app.call(*args).tap { write }
    end

    def log(keys)
      keys = keys.dup
      key = keys.pop.to_s
      log = keys.inject(self) { |log, k| log.key?(k.to_s) ? log[k.to_s] : log[k.to_s] = {} }
      log[key] = key.titleize
    end

    def dump(out = $stdout)
      out.puts(to_yml) unless empty?
    end

    def read
      if File.exists?(filename)
        data = YAML.load_file(filename) rescue nil
        self.replace(data) if data
      end
    end

    def write
      if filename
        FileUtils.mkdir_p(File.dirname(filename))
        File.open(filename, 'w+') { |f| f.write(to_yml) }
      end
    end

    def to_yml
      empty? ? '' : YAML.dump(Hash[*to_a.flatten])
    end

    def guess_filename
      if File.directory?("#{Dir.pwd}/log")
        "#{Dir.pwd}/log/missing_translations.log"
      else
        "/tmp/#{File.dirname(Dir.pwd)}-missing_translations.log"
      end
    end
  end
end
