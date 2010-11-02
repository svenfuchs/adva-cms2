class AdvaCategoriesAddLevelToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :level, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :categories, :level
  end
end


