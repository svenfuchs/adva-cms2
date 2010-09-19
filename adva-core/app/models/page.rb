class Page < Section
  has_one :article, :foreign_key => 'section_id', :inverse_of => :section, :dependent => :destroy
  validates_presence_of :article
  accepts_nested_attributes_for :article
  before_validation :ensure_default_article

  def body=(body)
    ensure_default_article
    article.body = body
  end

  protected

    def ensure_default_article
      build_article(:site => site, :section => self, :title => name) unless article.present?
    end
end