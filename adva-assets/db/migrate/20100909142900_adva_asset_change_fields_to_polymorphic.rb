class AdvaAssetChangeFieldsToPolymorphic < ActiveRecord::Migration

  def self.up
    drop_table :asset_assignments
    
    add_column :assets, :attachable_type, :string
    add_column :assets, :attachable_id, :integer
  end

  def self.down
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
    remove_column :assets, :attachable_type
    remove_column :assets, :attachable_id
  end

end