require_dependency 'section'

Section.class_eval do
  has_many :categories
  # Category.has_many_polymorphs :categorizables, :through => :categorizations, :foreign_key => 'category_id', :from => [:sections]
  # has_many :categories, :through => :categorizations, :as => :categorizable
  # has_many :categorizations
end
