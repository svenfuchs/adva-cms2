module Adva
  class Cnet
    module Importer
      class Product < Base
        class Row < Base::Row
          def import
            product.update_attributes!(attributes.except('ext_product_id'))
          end

          protected
            def product
              @prd ||= ::Cnet::Product.find_or_create_by_ext_product_id(attributes['ext_product_id'])
            end
        end
      end
    end
  end
end