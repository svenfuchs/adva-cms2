class AdvaAssetsCreateTables < ActiveRecord::Migration
  def self.up
    create_table :assets, :force => true do |t|
      t.string :file
      t.string :title
      t.string :description

      t.references :site
      t.references :user
      t.datetime   :created_at

      t.string :type

      t.timestamps
    end

    create_table :asset_assignments, :force => true do |t|
      t.integer  :obj_id
      t.integer  :asset_id
      t.integer  :position
      t.string   :label
      t.datetime :created_at
      t.boolean  :active
      t.integer  :weight
    end

    add_index :asset_assignments, [:obj_id, :asset_id], :unique => true
    add_index :asset_assignments, [:obj_id, :weight], :unique => true

  end

  def self.down
    drop_table :assets
    drop_table :asset_assignments
  end
end