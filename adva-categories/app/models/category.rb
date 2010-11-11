class Category < ActiveRecord::Base
  belongs_to :section
  validates_presence_of :section, :name

  acts_as_nested_set :scope => :section_id
  has_slug :scope => :section_id

  class << self
    def categorizable(table)
      Category.has_many_polymorphs :categorizables, :through => :categorizations, :foreign_key => 'category_id', :from => [table]
    end
  end
end
