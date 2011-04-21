# Make the view translation helper use the :rescue_format => :html option instead
# of rescuing exceptions itself.
#
# See https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/5969-bump-i18n-and-make-translationhelper-use-new-rescue_format-option#ticket-5969-8
# can be removed in 3.1
Gem.patching('rails', '3.0.7') do
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
