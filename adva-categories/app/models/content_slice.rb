require_dependency 'category'
require_dependency 'content'

Category.has_many_polymorphs :categorizables, :through => :categorizations, :foreign_key => 'category_id', :from => [:contents]
Content.has_many :categories, :through => :categorizations, :as => :categorizable
