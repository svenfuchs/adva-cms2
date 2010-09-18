class Page < Section
  has_one :article, :foreign_key => 'section_id', :inverse_of => :section, :dependent => :destroy
  validates_presence_of :article
  accepts_nested_attributes_for :article

  before_validation do
    build_article(:site => site, :section => self, :title => name) unless article.present?
  end
end