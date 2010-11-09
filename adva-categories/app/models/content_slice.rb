require_dependency 'category'
require_dependency 'content'

Category.has_many_polymorphs :categorizables, :through => :categorizations, :foreign_key => 'category_id', :from => [:contents]

Content.class_eval do
  has_many :categories, :through => :categorizations, :as => :categorizable
  accepts_nested_attributes_for :categorizations, :allow_destroy => true

  class << self
    def categorized(category_id)
      category     = Category.find(category_id)
      category_ids = category.self_and_descendants.map(&:id)
      includes(:categorizations).where(:categorizations => { :category_id => category_ids })
    end
  end
end
