require 'devise'
require 'devise/orm/active_record'

class AdvaCmsCreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.references :account

      t.database_authenticatable
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      t.timestamps

      t.string :roles
    end
  end

  def self.down
    drop_table :users
  end
end