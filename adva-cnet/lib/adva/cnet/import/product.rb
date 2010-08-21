module Adva
  class Cnet
    module Import
      class Product
        attr_reader :origin, :import
        
        def initialize(origin, import)
          @origin, @import = origin, import
        end
        
        def insert_statement
          sql = <<-sql
            INSERT INTO #{shop_database}.#{table_name} (product_number, manufacturer_part_number,
              sk_product_id, cnet_category_id, cnet_manufacturer_id, status, created_at, updated_at,
              cat_id, mf_id, mkt_id, img_id)
              SELECT #{cnet_database}.cds_prod.ProdID,
                #{cnet_database}.cds_prod.MfPN,
                (
                  SELECT #{sk_product_table_name}.id
                  FROM #{sk_product_table_name}
                  WHERE #{sk_product_table_name}.product_number = #{cnet_database}.cds_prod.ProdID
                ),
                (
                  SELECT #{category_table_name}.id
                  FROM #{category_table_name}
                  WHERE #{category_table_name}.cat_id = #{cnet_database}.cds_prod.CatID
                ),
                (
                  SELECT #{manufacturer_table_name}.id
                  FROM #{manufacturer_table_name}
                  WHERE #{manufacturer_table_name}.mf_id = #{cnet_database}.cds_prod.MfID
                ),
                (
                  SELECT #{cnet_database}.cds_catalog.StatusCode
                  FROM #{cnet_database}.cds_catalog
                  WHERE #{cnet_database}.cds_catalog.ProdID = #{cnet_database}.cds_prod.ProdID
                  ORDER BY timestamp DESC
                  LIMIT 1
                ),
                '#{created_at}', '#{updated_at}',
                #{cnet_database}.cds_prod.CatID, #{cnet_database}.cds_prod.MfID,
                #{cnet_database}.cds_prod.MktID, #{cnet_database}.cds_prod.ImgID
              FROM #{cnet_database}.cds_prod
            ON DUPLICATE KEY UPDATE
              manufacturer_part_number = VALUES(manufacturer_part_number),
              sk_product_id            = VALUES(sk_product_id),
              cnet_category_id         = VALUES(cnet_category_id),
              cnet_manufacturer_id     = VALUES(cnet_manufacturer_id),
              status                   = VALUES(status),
              updated_at               = VALUES(updated_at),
              cat_id                   = VALUES(cat_id),
              mf_id                    = VALUES(mf_id),
              mkt_id                   = VALUES(mkt_id),
              img_id                   = VALUES(img_id);
              #{Cnet::DataSource::QUERY_SEPARATOR}
          sql
        end
      end
    end
  end
end