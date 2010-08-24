class AdvaAssetsCreateTables < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :file
      t.string :title
      t.string :description

      t.references :site
      t.references :user
      t.datetime   :created_at

      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end