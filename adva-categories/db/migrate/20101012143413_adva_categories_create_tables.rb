class AdvaCategoriesCreateTables < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.references  :section
      t.integer     :parent_id
      t.integer     :lft, :null => false, :default => 0
      t.integer     :rgt, :null => false, :default => 0
      t.string      :name
      t.string      :slug
      t.string      :path
    end

    create_table :categorizations do |t|
      t.belongs_to :categorizable, :polymorphic => true
      t.references :category
    end
  end

  def self.down
    drop_table :categorizations
    drop_table :categories
  end
end

