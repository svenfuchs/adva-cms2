class Page < Section
  has_one :article, :foreign_key => 'section_id', :inverse_of => :section, :dependent => :destroy
  after_initialize :set_default_article
  accepts_nested_attributes_for :article
  validates_presence_of :article
  default_scope includes(:includes) rescue nil # will raise during migrations. how to remove the rescue clause?

  delegate :body=, :to => :article

  def set_default_article
    self.article ||= build_article(:site => site, :section => self, :title => name)
  end
end
