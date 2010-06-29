class Catalog < Section
  has_many :products, :foreign_key => 'section_id', :dependent => :destroy
end