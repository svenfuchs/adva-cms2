require Adva::Cnet.root.join('app/models/cnet/product')

class AdvaCnetProducts < ActiveRecord::Migration
  def self.up
    create_table :cnet_products do |t|
      t.references :product
      t.references :category
      t.references :manufacturer

      t.string :ext_product_id,           :limit => 40
      t.string :ext_category_id,          :limit => 2
      t.string :ext_manufacturer_id,      :limit => 10
      t.string :manufacturer_part_number, :limit => 40
      t.string :status,                   :limit => 4

      t.timestamps
    end
    indexes = %w(product_id category_id manufacturer_id ext_product_id ext_category_id ext_manufacturer_id)
    indexes.each { |column| add_index :cnet_products, column }

    Cnet::Product.create_translation_table!(
      :description => :text,
      :marketing_text => :text,
      :manufacturer_name => :string
    )
  end

  def self.down
    drop_table :cnet_products
    drop_table Cnet::Product.translations_table_name
  end
end