require_dependency 'content'

Content.class_eval do
  filters :body
end
