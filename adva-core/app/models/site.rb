# sections tree
# single-site/multi-site mode
# owners/resourcess

class Site < ActiveRecord::Base
  validates_presence_of :host, :name, :title, :sections
  validates_uniqueness_of :host

  belongs_to :site
  has_many :sections, :dependent => :destroy, :inverse_of => :site
  has_many :pages

  accepts_nested_attributes_for :sections

  # validates_presence_of :home_section
  # has_one  :home_section, :class_name => 'Section', :conditions => 'parent_id IS NULL', :order => 'lft'
end