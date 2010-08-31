# TODO 
# - fix CatalogInfo import, so status is not empty
# - multiple locales

module Adva
  class Cnet
    module Extractor
      class Product < Base
        def column_names
          %w(ext_product_id ext_category_id ext_manufacturer_id manufacturer_part_number manufacturer_name description marketing_text status)
        end
        
        def origin_select_statements
          <<-sql
            SELECT
              cds_prod."ProdID",
              cds_prod."CatID",
              cds_prod."MfID",
              cds_prod."MfPN",                
              (
                SELECT cds_vocde."Text"
                FROM cds_vocde
                WHERE cds_vocde."ID" = cds_prod."MfID"
              ),                
              (
                SELECT cds_stdnde."Description"
                FROM cds_stdnde
                WHERE cds_stdnde."ProdID" = cds_prod."ProdID"
              ),                
              (
                SELECT cds_mktde."Description"
                FROM cds_mktde
                WHERE cds_mktde."MktID" = cds_prod."MktID"
              ),
              (
                SELECT cds_catalog."StatusCode"
                FROM cds_catalog
                WHERE cds_catalog."ProdID" = cds_prod."ProdID"
              )
            FROM cds_prod
          sql
        end
      end
    end
  end
end