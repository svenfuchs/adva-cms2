class Section < ActiveRecord::Base
  # to make url_for(site, section) use site_section, not site_[child_class_name]
  def self.model_name
    self == Section ? super : Section.model_name
  end
  
  belongs_to :site, :inverse_of => :sections
  validates_presence_of :site, :title

  # has_option :contents_per_page, :default => 15
  # has_permalink :title, :url_attribute => :permalink, :sync_url => true,
  #   :only_when_blank => true, :scope => [ :site_id, :parent_id ]
  # validates_uniqueness_of :permalink, :scope => [:site_id, :parent_id]

  mattr_accessor :types
  self.types = []

  class << self
    def inherited(child)
      types << child.name
      super
    end
  end

  def type
    read_attribute(:type) || 'Section'
  end
  
  def attributes_protected_by_default
    default = [ self.class.primary_key ] # , self.class.inheritance_column
    default << 'id' unless self.class.primary_key.eql? 'id'
    default
  end
end