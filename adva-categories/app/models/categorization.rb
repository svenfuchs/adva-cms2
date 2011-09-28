class Categorization < ActiveRecord::Base
  belongs_to :category
  accepts_nested_attributes_for :category

  # used to count the categories in the Categorizable.uncategorized scope
  def self.subselectively_count_categories_for(model)
    ct = arel_table
    ct.project( ct[:category_id].count ).
      where( ct[:categorizable_type].eq(model.name) ).
      where( ct[:categorizable_id].eq(model.arel_table[:id]) )
  end
end

