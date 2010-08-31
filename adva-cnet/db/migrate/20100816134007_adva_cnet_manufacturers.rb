require Adva::Cnet.root.join('app/models/cnet/manufacturer')

class AdvaCnetManufacturers < ActiveRecord::Migration
  def self.up
    create_table :cnet_manufacturers do |t|
      t.string :ext_manufacturer_id, :limit => 40
      t.timestamps
    end
    add_index :cnet_manufacturers, :ext_manufacturer_id

    Cnet::Manufacturer.create_translation_table!(
      :name => :string
    )
  end

  def self.down
    drop_table :cnet_manufacturers
    drop_table Cnet::Manufacturer.translations_table_name
  end
end