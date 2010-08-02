class AdvaCoreCreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.references :site
      t.references :parent
      t.integer    :lft
      t.integer    :rgt
      t.string     :type
      t.string     :title
    end
  end

  def self.down
    drop_table :sections
  end
end