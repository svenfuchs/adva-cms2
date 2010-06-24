class Blog < Section
  has_many :articles, :foreign_key => 'section_id', :dependent => :destroy
end