module Adva
  class Cnet
    module Importer
      class Category
        class Row < Base::Row
          def import
            category.update_attributes!(attributes.except('ext_category_id'))
          end

          protected
            def category
              @prd ||= ::Cnet::Category.find_or_create_by_ext_category_id(attributes['ext_category_id'])
            end
        end
      end
    end
  end
end