begin
  require 'webrat'
rescue LoadError
end
# require 'webrat/core/logging'
require 'gem_patching'

Gem.patching('webrat', '0.7.0') do
  Webrat::FileField.class_eval do
    include ActionDispatch::TestProcess

    def test_uploaded_file
      return "" if @value.blank?

      case Webrat.configuration.mode
      when :rails
        if content_type
          # Rails 3 does not have an ActionController::TestUploadedFile anymore
          Rack::Test::UploadedFile.new(@value, content_type)
        else
          Rack::Test::UploadedFile.new(@value)
        end
      when :rack, :merb
        Rack::Test::UploadedFile.new(@value, content_type)
      end
    end
  end
end if defined?(Webrat)
