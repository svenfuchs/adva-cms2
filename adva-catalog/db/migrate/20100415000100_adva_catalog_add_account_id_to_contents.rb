class AdvaCatalogAddAccountIdToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :account_id, :integer
  end

  def self.down
    remove_column :contents, :account_id
  end
end