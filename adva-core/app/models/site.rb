# single-site/multi-site mode
# owners/resources

class Site < ActiveRecord::Base
  validates_presence_of :host, :name, :title
  validates_uniqueness_of :host

  belongs_to :account
  has_many :sections, :inverse_of => :site, :dependent => :destroy
  has_many :pages, :dependent => :destroy

  accepts_nested_attributes_for :sections

  has_one  :home_section, :class_name => 'Section', :conditions => 'parent_id IS NULL', :order => 'lft'
end