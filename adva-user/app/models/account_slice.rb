Account.class_eval do
  has_many :users, :dependent => :destroy
end