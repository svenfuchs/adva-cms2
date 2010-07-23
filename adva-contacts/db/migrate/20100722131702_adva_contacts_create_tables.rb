class AdvaContactsCreateTables < ActiveRecord::Migration
  def self.up
    create_table :contact_addresses do |t|
      t.references :addressable, :polymorphic => true
      t.string  :street
      t.string  :country
      t.string  :delivery
      t.string  :extended
      t.string  :locality
      t.string  :location
      t.string  :pobox
      t.string  :postalcode
      t.boolean :preferred
      t.string  :region

      t.timestamps
    end

    create_table :contacts do |t|
      t.string :gender
      t.string :prefix,      :maximum => 32
      t.string :first_name,  :maximum => 32
      t.string :middle_name, :maximum => 32
      t.string :last_name,   :maximum => 32
      t.string :suffix,      :maximum => 32
      t.date   :born_on
      t.string :photo
      t.string :sound
      t.string :nickname
      t.text   :note
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end