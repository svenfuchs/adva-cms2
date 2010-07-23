class AdvaCartCreateTables < ActiveRecord::Migration
  def self.up
    create_table :itemizeds do |t|
      t.string :type
      t.timestamps
    end

    create_table :orders do |t|
      t.string :type
      t.timestamps
    end

    create_table :items do |t|
      t.references :itemized
      t.references :product
      t.integer    :quantity
      t.integer    :price
      t.timestamps
    end
  end

  def self.down
    drop_table :items
    drop_table :orders
    drop_table :itemizeds
  end
end
