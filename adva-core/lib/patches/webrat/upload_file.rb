begin
  require 'webrat'
rescue LoadError
end
# require 'webrat/core/logging'
require 'gem_patching'

Gem.patching('webrat', '0.7.1') do
  Webrat::FileField.class_eval do
    def test_uploaded_file
      return "" if @original_value.blank?

      case Webrat.configuration.mode
      when :rails
        if content_type
          Rack::Test::UploadedFile.new(@original_value, content_type, false)
        else
          Rack::Test::UploadedFile.new(@original_value, nil, false)
        end
      when :rack, :merb
        Rack::Test::UploadedFile.new(@original_value, content_type)
      end
    end
  end
end if defined?(Webrat)