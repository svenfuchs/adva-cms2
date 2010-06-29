class AdvaCoreCreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts
  end

  def self.down
    drop_table :accounts
  end
end
