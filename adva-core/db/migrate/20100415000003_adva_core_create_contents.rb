class AdvaCoreCreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.references  :site
      t.references  :section
      t.string      :type
      t.string      :title, :default => '', :null => false
      t.string      :slug,  :default => '', :null => false
      t.text        :body,  :default => '', :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end