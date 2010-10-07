class AdvaMarkupAddColumns < ActiveRecord::Migration
  def self.up
    add_column :contents, :filter, :string
    add_column :contents, :body_html, :text
  end

  def self.down
    drop_column :contents, :body_html
    drop_column :contents, :filter
  end
end
