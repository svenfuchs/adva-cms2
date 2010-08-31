require Adva::Cnet.root.join('app/models/cnet/product')

class AdvaCnetAttributesColumns < ActiveRecord::Migration
  def self.up
    add_column :attributes_keys, :ext_key_id, :string
    add_column :attributes_values, :ext_value_id, :string
    add_column :attributes_values, :ext_product_id, :string
    
    add_index :attributes_keys, :ext_key_id
    add_index :attributes_values, :ext_value_id
    add_index :attributes_values, :ext_product_id
  end

  def self.down
    remove_index :attributes_values, :ext_product_id
    remove_index :attributes_values, :ext_value_id
    remove_index :attributes_keys, :ext_key_id

    remove_column :attributes_values, :ext_product_id
    remove_column :attributes_values, :ext_value_id
    remove_column :attributes_keys, :ext_key_id
  end
end