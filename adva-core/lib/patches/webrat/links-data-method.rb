require 'gem-patching'

Gem.patching('webrat', '0.7.2') do
  Webrat::Link.class_eval do
    def http_method
      if !@element["data-method"].blank?
        @element["data-method"]
      elsif !onclick.blank? && onclick.include?("f.submit()")
        http_method_from_js_form
      else
        :get
      end
    end
  end
end if defined?(Webrat)
