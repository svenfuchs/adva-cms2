class Section < ActiveRecord::Base
  belongs_to :site, :inverse_of => :sections
  validates_presence_of :site, :title
  
  acts_as_nested_set

  # has_option :contents_per_page, :default => 15
  # validates_uniqueness_of :slug, :scope => [:site_id, :parent_id]

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

  def root?
    id == Section.order(:id).first.try(:id) # TODO
  end

  def attributes_protected_by_default
    default = [self.class.primary_key]
    default << 'id' unless self.class.primary_key.eql? 'id'
    default
  end
end