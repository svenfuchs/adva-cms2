# sections tree
# single-site/multi-site mode
# owners/resources

class Site < ActiveRecord::Base
  validates_presence_of :host, :name, :title
  validates_uniqueness_of :host
  # validates presence of at least one section
  
  has_many :sections, :dependent => :destroy, :inverse_of => :site
  
  accepts_nested_attributes_for :sections
end