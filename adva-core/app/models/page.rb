class Page < Section
  has_one :article, :foreign_key => 'section_id', :inverse_of => :section, :dependent => :destroy, :default => :build_default_article
  accepts_nested_attributes_for :article
  delegate :title=, :body=, :to => :article

  def build_default_article
    build_article(:site => site, :title => name)
  end
end
