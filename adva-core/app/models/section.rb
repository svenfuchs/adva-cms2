class Section < ActiveRecord::Base
  belongs_to :site, :inverse_of => :sections
  validates_presence_of :site, :title
  
  has_slug :scope => :site_id
  acts_as_nested_set # FIXME scope to site_id

  # has_option :contents_per_page, :default => 15
  # validates_uniqueness_of :slug, :scope => [:site_id, :parent_id]

  # after_move :update_path
  # after_move :update_paths

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
  
  def path
    path = read_attribute(:path)
    path == site.sections.root.read_attribute(:path) ? '' : path
  end

  def root?
    super && previous_sibling.nil?
  end

  def attributes_protected_by_default
    default = [self.class.primary_key]
    default << 'id' unless self.class.primary_key.eql? 'id'
    default
  end
  
  # def update_paths
  #   
  # end
  
  # def update_path
  #   path = self_and_ancestors.reject(&:root?).map(&:slug).join('/')
  #   update_attributes!(:path => path) unless self.path == path
  # end

end