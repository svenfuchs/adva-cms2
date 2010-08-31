module Adva
  class Cnet
    module Finalizer
      class Attribute < Base
        def initialize
          @table_name = "attributes_values"
        end

        def synchronize_foreign_key_statements
          updates = {
            :attributable_id => "SELECT id FROM cnet_products WHERE cnet_products.ext_product_id = #{table_name}.ext_product_id",
            :attributable_type => "'Cnet::Product'"
          }
          updates.map { |key, subselect| synchronize_foreign_key_statement(key, subselect) }
        end
      end
    end
  end
end