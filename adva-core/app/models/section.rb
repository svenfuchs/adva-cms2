class Section < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :site, :inverse_of => :sections

  validates_presence_of :site, :name, :slug
  # validates_uniqueness_of :slug, :scope => [:site_id, :parent_id]

  has_slug :scope => :site_id
  acts_as_nested_set :scope => :site_id

  mattr_accessor :types
  self.types = []

  class << self
    def inherited(child)
      types << child.name
      super
    end

    def type_names
      @type_names ||= types.map(&:underscore)
    end
  end

  def type
    read_attribute(:type) || 'Section'
  end

  def path
    home? ? '' : super
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
