class Blog < Section
  has_many :posts, :foreign_key => 'section_id', :dependent => :destroy

  accepts_nested_attributes_for :posts
end