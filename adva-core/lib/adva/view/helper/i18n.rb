I18n::Backend::Simple.send(:include, I18n::Backend::Cascade)

# TODO no idea how to use a module here :/
ActionView::Base.class_eval do
  def translate(key, options = {})
    # TODO must be fixed in I18n::Backend::Cascade
    options.merge!(:cascade => { :step => 1, :offset => 2, :skip_root => false }) if key.to_s.include?('.')
    super(key, options)
  end
  alias t translate
end

# TODO submit a Rails patch
ActionView::Helpers::TranslationHelper.module_eval do
  def translate(key, options = {})
    options.merge!(:wrap_exception => true) unless options.key?(:wrap_exception)
    translation = I18n.translate(scope_key_by_partial(key), options)
    if html_safe_translation_key?(key) && translation.respond_to?(:html_safe)
      translation.html_safe
    else
      translation
    end
  end
  alias :t :translate
end

