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
