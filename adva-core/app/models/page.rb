class Page < Section
  default_scope includes(:includes) rescue nil # would raise during migrations. how to remove the rescue clause?
  has_one :article, :foreign_key => 'section_id', :inverse_of => :section, :dependent => :destroy
  accepts_nested_attributes_for :article
  validates_presence_of :article

  delegate :title=, :body=, :to => :article

  # TODO extract this stuff to a has_one extension that excepts a :default key
  def article_with_default
    article_without_default || self.article = Article.new(:site => site, :section => self, :title => name)
  end
  alias_method_chain :article, :default
end
