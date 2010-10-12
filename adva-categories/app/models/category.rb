class Category < ActiveRecord::Base
  acts_as_nested_set :scope => :section_id
  has_slug :scope => :section_id

  belongs_to :section
  # has_many :categorizations, :dependent => :delete_all
  # has_many :categorizables, :through => :categorizations

  validates_presence_of :section, :name
end
