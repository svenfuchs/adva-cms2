class Article < Content
  validates_presence_of :title
  
  belongs_to :site
end