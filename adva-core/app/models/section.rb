class Section < ActiveRecord::Base
  belongs_to :site, :inverse_of => :sections
  validates_presence_of :site, :title

  # has_option :contents_per_page, :default => 15
  # validates_uniqueness_of :slug, :scope => [:site_id, :parent_id]

  mattr_accessor :types
  self.types = []

  class << self
    def inherited(child)
      types << child.name
      super
    end

    def root
      first
    end
  end

  def type
    read_attribute(:type) || 'Section'
  end

  def root_section?
    id == Section.order(:id).first.try(:id) # TODO
  end

  def attributes_protected_by_default
    default = [ self.class.primary_key ] # , self.class.inheritance_column
    default << 'id' unless self.class.primary_key.eql? 'id'
    default
  end
end