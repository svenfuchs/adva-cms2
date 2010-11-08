# Make the view translation helper use the :rescue_format => :html option instead
# of rescuing exceptions itself.
Gem.patching('rails', '3.0.1') do
  ActionView::Helpers::TranslationHelper.module_eval do
    def translate(key, options = {})
      options.merge!(:rescue_format => :html) unless options.key?(:rescue_format)
      translation = I18n.translate(scope_key_by_partial(key), options)
      if html_safe_translation_key?(key) && translation.respond_to?(:html_safe)
        translation.html_safe
      else
        translation
      end
    end
    alias :t :translate
  end
end
