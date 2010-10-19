class Section < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :site, :inverse_of => :sections

  # unfortunate, but moving this to a adva-categories/section_slice breaks because
  # class_inheritable_attributes get out of sync and crash. this might change if we
  # were able to load code slices lazily
  if Adva.engine?(:categories)
    has_many :categories, :foreign_key => :section_id
    accepts_nested_attributes_for :categories
  end

  validates_presence_of :site, :name, :slug

  has_slug :scope => :site_id
  acts_as_nested_set # FIXME must scope to site_id
  serialize :options # FIXME should be in has_options, but the class_inheritable_accessor :serialized_attributes seems to get out of sync

  # validates_uniqueness_of :slug, :scope => [:site_id, :parent_id]

  mattr_accessor :types
  self.types ||= [] # FIXME model is loaded twice, at least in cucumber

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
