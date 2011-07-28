require_dependency 'page'

Page.class_eval do
  delegate :filter=, :to => :article
end

