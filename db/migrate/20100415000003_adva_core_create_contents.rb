class AdvaCoreCreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.references  :site
      t.references  :section
      t.string      :type
      t.string      :title
      t.text        :body
    end
  end

  def self.down
    drop_table :sections
  end
end