class AdvaContactsCreateTables < ActiveRecord::Migration
  
  create_table :addresses, :force => true do |t|
    t.references  :user
    t.string      :address
    t.string      :city
    t.timestamps
  end
  
  def self.down
    drop_table :addresses
  end
  
end