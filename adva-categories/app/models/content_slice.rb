require_dependency 'category'
require_dependency 'content'

Category.has_many_polymorphs :categorizables, :through => :categorizations, :foreign_key => 'category_id', :from => [:contents]

Content.class_eval do
  has_many :categories, :through => :categorizations, :as => :categorizable

  class << self
    def categorized(category_id)
      includes(:categorizations).where(:categorizations => { :category_id => category_id })
    end
  end
end
