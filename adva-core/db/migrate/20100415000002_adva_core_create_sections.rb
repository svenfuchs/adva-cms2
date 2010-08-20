class AdvaCoreCreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.references :site
      t.references :parent
      t.integer    :lft
      t.integer    :rgt
      t.string     :type
      t.string     :title, :default => '', :null => false
      t.string     :slug,  :default => '', :null => false
      t.string     :path,  :default => '', :null => false
      t.string     :level
      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end