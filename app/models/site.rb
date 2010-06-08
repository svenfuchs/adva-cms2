# sections tree
# single-site/multi-site mode
# owners/resources

class Site < ActiveRecord::Base
  validates_presence_of :host, :name, :title
  validates_uniqueness_of :host
  validate :presence_of_home_section

  has_many :sections, :dependent => :destroy, :inverse_of => :site

  accepts_nested_attributes_for :sections

  # validates_presence_of :home_section
  # has_one  :home_section, :class_name => 'Section', :conditions => 'parent_id IS NULL', :order => 'lft'

  protected

    def presence_of_home_section
      errors.add(:base, 'Site needs a home section') if sections.empty?
    end

end