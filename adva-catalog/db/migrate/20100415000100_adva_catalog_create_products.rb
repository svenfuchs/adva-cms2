class AdvaCatalogCreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.references :account
      t.string     :name
      t.string     :number
      t.text       :description
    end
  end

  def self.down
    drop_table :products
  end
end