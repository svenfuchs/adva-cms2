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
    add_index :categorizations, :category_id
    add_index :categorizations, :categorizable_id
    # TODO: add this index later, when the cnet product_categorization finalizer has been adjusted
    # so that existing categorizations between products and categories get overwritten by setting
    # the source attribute to 'cnet'.
    # add_index :categorizations, [:category_id, :categorizable_id, :categorizable_type],
    #   :unique => true, :name => 'index_categorizations_on_cat_and_categorizable'
  end

  def self.down
    drop_table :categorizations
    drop_table :categories
  end
end

