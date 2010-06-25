class Post < Content
  validates_presence_of :title
  
  belongs_to :site
  belongs_to :section
end