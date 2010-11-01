I18n::Backend::Simple.send(:include, I18n::Backend::Cascade)

ActionView::Helpers.module_eval do
  module CascadingTranslations
    def translate(key, options = {})
      options.merge!(:cascade => { :step => 1, :offset => 2, :skip_root => false })
      super
    end
    alias t translate
  end
  include CascadingTranslations
end
