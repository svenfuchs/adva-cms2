class AdvaCacheCreateTables < ActiveRecord::Migration
  def self.up
    create_table :cache_taggings, :force => true do |t|
      t.string :url
      t.string :tag
    end
  end

  def self.down
    drop_table :cache_taggings
  end
end