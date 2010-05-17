class Page < Section
  after_create :create_initial_article
  
  has_one :article, :foreign_key => 'section_id', :dependent => :destroy
  
  protected
    
    def create_initial_article
      create_article :site => site, :title => title
    end
end