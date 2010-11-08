require_dependency 'content'

Content.class_eval do
  filters :body

  def filter
    read_attribute(:filter) || (section.respond_to?(:default_filter) ? section.default_filter : nil)
  end
end
