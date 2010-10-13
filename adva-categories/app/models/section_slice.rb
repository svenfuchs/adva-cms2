require_dependency 'section'

Section.class_eval do
  has_many :categories
end
