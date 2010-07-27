class AdvaCatalogCreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.references :account
      t.string     :name
      t.string     :number
      t.text       :description
      t.integer    :price
      t.integer    :vat
    end
  end

  def self.down
    drop_table :products
  end
end