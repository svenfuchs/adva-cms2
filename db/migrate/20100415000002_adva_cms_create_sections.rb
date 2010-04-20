class AdvaCmsCreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string      :type
      t.references  :site
      t.string      :title
    end
  end

  def self.down
    drop_table :sections
  end
end