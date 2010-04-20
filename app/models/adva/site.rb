# sections tree
# single-site/multi-site mode
# owners/resources

class Adva::Site < ActiveRecord::Base
  validates_presence_of :host, :name, :title
  validates_uniqueness_of :host
  
  has_many :sections, :dependent => :destroy
end