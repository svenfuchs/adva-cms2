class Blog < Section
  has_many :posts, :foreign_key => 'section_id', :dependent => :destroy
end