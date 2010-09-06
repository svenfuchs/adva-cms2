Account.class_eval do
  has_many :users, :dependent => :destroy
  accepts_nested_attributes_for :users
end