class AdvaCmsCreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :name
      t.string :host
      t.string :title
      t.string :subtitle
      t.string :timezone
    end
  end

  def self.down
    drop_table :sites
  end
end