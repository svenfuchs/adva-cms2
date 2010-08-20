class AdvaCoreCreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.references :account
      t.string :name,  :default => '', :null => false
      t.string :host,  :default => '', :null => false
      t.string :title, :default => '', :null => false
      t.string :subtitle
      t.string :timezone
      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end