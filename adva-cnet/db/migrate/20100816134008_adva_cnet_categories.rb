require Adva::Cnet.root.join('app/models/cnet/category')

class AdvaCnetCategories < ActiveRecord::Migration
  def self.up
    create_table :cnet_categories do |t|
      t.string :ext_category_id, :limit => 40
      t.timestamps
    end
    add_index :cnet_categories, :ext_category_id

    Cnet::Category.create_translation_table!(
      :name => :string
    )
  end

  def self.down
    drop_table :cnet_categories
    drop_table Cnet::Category.translations_table_name
  end
end