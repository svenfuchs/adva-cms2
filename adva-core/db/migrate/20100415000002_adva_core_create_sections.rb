class AdvaCoreCreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.references :site
      t.references :parent
      t.integer    :lft
      t.integer    :rgt
      t.string     :type
      t.string     :name, :default => '', :null => false
      t.string     :slug, :default => '', :null => false
      t.string     :path, :default => '', :null => false
      t.integer    :level
      t.text       :options
      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
