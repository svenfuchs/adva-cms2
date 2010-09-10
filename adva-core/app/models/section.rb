class Section < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :site, :inverse_of => :sections
  validates_presence_of :site, :title, :slug

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
    _path == site.home_section.send(:_path) ? '' : _path
  end

  def home?
    root? && previous_sibling.nil?
  end

  def attributes_protected_by_default
    default = [self.class.primary_key]
    default << 'id' unless self.class.primary_key.eql? 'id'
    default
  end

  protected

    def _path
      read_attribute(:path)
    end
end