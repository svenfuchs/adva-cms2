Section.class_eval do
  has_many :categories, :foreign_key => :section_id
  accepts_nested_attributes_for :categories
end
