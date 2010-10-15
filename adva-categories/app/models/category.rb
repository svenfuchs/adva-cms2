class Category < ActiveRecord::Base
  acts_as_nested_set :scope => :section_id
  has_slug :scope => :section_id

  belongs_to :section

  validates_presence_of :section, :name
end
