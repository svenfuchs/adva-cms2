class AdvaCoreAddPublishedAtToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :published_at, :datetime
  end

  def self.down
    remove_column :contents, :published_at
  end
end
