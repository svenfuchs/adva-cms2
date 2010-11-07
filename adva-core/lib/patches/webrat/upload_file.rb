require 'gem_patching'

Gem.patching('webrat', '0.7.2') do
  Webrat::FileField.class_eval do
    include ActionDispatch::TestProcess

    def test_uploaded_file
      return "" if @original_value.blank?

      case Webrat.configuration.mode
      when :rails
        if content_type
          # Rails 3 does not have an ActionController::TestUploadedFile anymore
          Rack::Test::UploadedFile.new(@original_value, content_type)
        else
          Rack::Test::UploadedFile.new(@original_value)
        end
      when :rack, :merb
        Rack::Test::UploadedFile.new(@original_value, content_type)
      end
    end
  end
end if defined?(Webrat)
