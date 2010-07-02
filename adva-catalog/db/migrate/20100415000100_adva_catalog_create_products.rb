class AdvaCatalogCreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.references  :account
      t.string      :title
      t.text        :body
    end
  end

  def self.down
    drop_table :products
  end
end