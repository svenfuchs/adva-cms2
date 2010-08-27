begin
  require 'webrat'
rescue LoadError
end
# require 'webrat/core/logging'
require 'gem_patching'

Gem.patching('webrat', '0.7.1') do
  Webrat::FileField.class_eval do
    include ActionDispatch::TestProcess

    def test_uploaded_file
      return "" if @original_value.blank?

      case Webrat.configuration.mode
      when :rails
        if content_type
          Rack::Test::UploadedFile.new(File.expand_path("../../../../../adva-assets/test/fixtures/#{@original_value}", __FILE__), content_type, false)
        else
          Rack::Test::UploadedFile.new(File.expand_path("../../../../../adva-assets/test/fixtures/#{@original_value}", __FILE__), nil, false)
        end
      when :rack, :merb
        Rack::Test::UploadedFile.new(@original_value, content_type)
      end
    end
  end
end if defined?(Webrat)