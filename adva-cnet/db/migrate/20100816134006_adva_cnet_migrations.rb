class AdvaCnetMigrations < ActiveRecord::Migration
  def self.up
    create_table :cnet_products do |t|
      t.references :product
      t.references :category
      t.references :manufacturer

      t.string :product_number,           :limit => 40
      t.string :manufacturer_part_number, :limit => 40
      t.string :status,                   :limit => 4

      t.string :cat_id,  :limit => 2
      t.string :mkt_id,  :limit => 10
      t.string :img_id,  :limit => 10
      t.string :mf_id,   :limit => 10

      t.timestamps
    end

    add_index :cnet_products, :product_number, :unique => true,
      :name => 'ix_cnet_products_product_number'

    Cnet::Product.create_translation_table!(
      :description => :text, 
      :marketing_text => :text
    )

    add_index Cnet::Product.translations_table_name, [:locale, :cnet_product_id], :unique => true, 
      :name => 'idx_cnet_product_translations_locale_cnet_product_id'
  end

  def self.down
    drop_table :cnet_products
    drop_table Cnet::Product.translations_table_name
  end
end