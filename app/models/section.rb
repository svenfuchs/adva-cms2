class Section < ActiveRecord::Base
  # to make url_for(site, section) use site_section, not site_[child_class_name]
  def self.model_name
    self == Section ? super : Section.model_name
  end
  
  belongs_to :site
  validates_presence_of :site, :title

  # has_option :contents_per_page, :default => 15
  # has_permalink :title, :url_attribute => :permalink, :sync_url => true,
  #   :only_when_blank => true, :scope => [ :site_id, :parent_id ]
  # validates_uniqueness_of :permalink, :scope => [:site_id, :parent_id]

  class << self
    def types
      subclasses.map(&:name)
    end
  end

  def type
    read_attribute(:type) || 'Section'
  end
end