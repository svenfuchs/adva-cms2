class Section < ActiveRecord::Base
  extend ActiveSupport::Memoizable

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

    def paths
      all(:select => :path).map(&:path)
    end
  end

  def type
    read_attribute(:type) || 'Section'
  end
  memoize :type

  def path
    read_attribute(:path) == root_path ? '' : read_attribute(:path)
  end
  memoize :path

  def root?
    super && previous_sibling.nil?
  end
  memoize :root?

  def attributes_protected_by_default
    default = [self.class.primary_key]
    default << 'id' unless self.class.primary_key.eql? 'id'
    default
  end

  protected

    def root_path
      site && (root = site.sections.root) && root.read_attribute(:path)
    end
    memoize :root_path

end