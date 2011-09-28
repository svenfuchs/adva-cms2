module Adva
  module Categorizable
    def categorizable
      unless categorizable?
        Category.categorizable(name.underscore.pluralize.to_sym)
        has_many :categories, :through => :categorizations, :as => :categorizable
        accepts_nested_attributes_for :categorizations, :allow_destroy => true
        extend ClassMethods
      end
    end

    def categorizable?
      singleton_class.included_modules.include?(ClassMethods)
    end

    module ClassMethods
      def categorized(category_id)
        return uncategorized if category_id == 0
        category     = Category.find(category_id)
        category_ids = category.self_and_descendants.map(&:id)
        includes(:categorizations).where(:categorizations => { :category_id => category_ids })
      end

      def uncategorized
        where( "0 = (#{Categorization.subselectively_count_categories_for(self).to_sql})" )
      end
    end

    ActiveRecord::Base.extend(self)
  end
end
