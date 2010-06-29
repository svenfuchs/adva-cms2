class AdvaCoreCreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string     :type
      t.references :site
      t.string     :title
      t.references :parent
      t.integer    :lft
      t.integer    :rgt
    end
  end

  def self.down
    drop_table :sections
  end
end