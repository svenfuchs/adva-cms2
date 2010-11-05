I18n::Backend::Simple.send(:include, I18n::Backend::Cascade)

# TODO should be a module, but i have no idea how/where to include one :/
ActionView::Base.class_eval do
  def translate(key, options = {})
    super(key, options.merge(:cascade => { :offset => 2, :skip_root => false }))
  end
  alias t translate
end

