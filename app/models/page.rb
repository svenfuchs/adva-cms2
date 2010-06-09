class Page < Section
  after_create :create_initial_article
  
  has_one :article, :foreign_key => 'section_id', :dependent => :destroy
  
  accepts_nested_attributes_for :article
  
  protected
    
    def create_initial_article
      create_article :site => site, :title => title unless article.present?
    end
end