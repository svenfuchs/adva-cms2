class Blog < Section
  has_many :posts, :foreign_key => 'section_id', :dependent => :destroy, :order => 'created_at DESC'
  # has_option :contents_per_page, :default => 15

  accepts_nested_attributes_for :posts
end