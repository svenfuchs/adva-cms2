require 'minimal/template'
require 'tidy_ffi'

module Minimal::Template::BeautifyHtml
  OPTIONS = {
    :indent        => 'yes',
    :indent_spaces => '2',
    :wrap          => '0'
  }

  class << self
    def after(controller)
      # controller.response.body = tidy(controller.response.body) if controller.request.format.html?
    end

    def tidy(html)
      TidyFFI::Tidy.new(html, OPTIONS).clean
    end
  end
end