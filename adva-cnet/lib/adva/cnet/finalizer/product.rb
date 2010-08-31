module Adva
  class Cnet
    module Finalizer
      class Product < Base
        def initialize
          @table_name = "cnet_products"
        end

        def synchronize_foreign_key_statements
          updates = {
            :product_id      => "SELECT id FROM products WHERE products.number = #{table_name}.ext_product_id",
            :category_id     => "SELECT id FROM cnet_categories WHERE cnet_categories.ext_category_id = #{table_name}.ext_category_id",
            :manufacturer_id => "SELECT id FROM cnet_manufacturers WHERE cnet_manufacturers.ext_manufacturer_id = #{table_name}.ext_manufacturer_id"
          }
          updates.map { |key, subselect| synchronize_foreign_key_statement(key, subselect) }
        end
      end
    end
  end
end