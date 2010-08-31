class AdvaAttributesCreateTables < ActiveRecord::Migration
  def self.up
    create_table :attributes_keys do |t|
      # t.string  :type, :limit => 50, :null => false # Specification, SpecificationGroup, SearchableAttribute
      t.string  :value_type, :limit => 50           # for typecasting values (only Attributes)
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :level
      t.string  :slug
      t.string  :path
      t.timestamps
    end
    add_index :attributes_keys, :parent_id
    # TODO :lft, :rgt

    create_table :attributes_key_translations do |t|
      t.references :attributes_key
      t.string :locale, :limit => 10, :null => false
      t.string :name, :limit => 255
    end
    add_index :attributes_key_translations, :attributes_key_id

    create_table :attributes_values do |t|
      t.references :key
      t.references :attributable, :polymorphic => true
      t.float :numeric_value
    end
    add_index :attributes_values, :key_id
    add_index :attributes_values, [:attributable_id, :attributable_type]

    create_table :attributes_value_translations do |t|
      t.references :attributes_value
      t.string :locale, :limit => 10, :null => false
      t.text   :display_value
      t.string :unit, :limit => 255
    end
    add_index :attributes_value_translations, :attributes_value_id
  end

  def self.down
    drop_table :attributes_value_translations
    drop_table :attributes_values
    drop_table :attributes_key_translations
    drop_table :attributes_keys
  end
end