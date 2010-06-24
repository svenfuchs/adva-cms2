class Page < Section
  has_one :article, :foreign_key => 'section_id', :dependent => :destroy
  validates_presence_of :article
  accepts_nested_attributes_for :article

  before_validation do
    build_article(:site => site, :section => self, :title => title) unless article.present?
  end
end