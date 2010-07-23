class AdvaContactsCreateTables < ActiveRecord::Migration
  def self.up
    create_table :contact_addresses do |t|
      t.references :addressable, :polymorphic => true
      t.string  :street
      t.string  :postalcode
      t.string  :city
      t.string  :region
      t.string  :country

      t.string  :pobox
      t.string  :delivery
      t.string  :extended
      t.string  :location
      t.boolean :preferred

      t.timestamps
    end

    create_table :contacts do |t|
      t.string :gender
      t.string :prefix,      :maximum => 32
      t.string :first_name,  :maximum => 32
      t.string :middle_name, :maximum => 32
      t.string :last_name,   :maximum => 32
      t.string :suffix,      :maximum => 32
      t.string :nickname

      t.date   :born_on
      t.string :photo
      t.string :sound
      t.text   :note
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end