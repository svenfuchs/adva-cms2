class Site < ActiveRecord::Base
  validates_presence_of :host, :name, :title
  validates_uniqueness_of :host

  belongs_to :account
  has_many :sections, :inverse_of => :site, :dependent => :destroy
  has_many :pages, :dependent => :destroy

  accepts_nested_attributes_for :account, :sections

  has_one  :home_section, :class_name => 'Section', :conditions => 'parent_id IS NULL', :order => 'lft'

  class << self
    def install(params)
      User.skip_callbacks do # TODO remove user dependency, test failure
        site = Site.create!(params[:site])
        site.account.users.first.confirm!
        site
      end
    end
  end
end