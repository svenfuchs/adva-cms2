module Adva
  class Cnet
    module Extractor
      class Manufacturer < Base
        def column_names
          %w(ext_manufacturer_id name)
        end
        
        def origin_select_statements
          <<-sql
            SELECT
              cds_prod."MfID",
              (
                SELECT cds_vocde."Text"
                FROM cds_vocde
                WHERE cds_vocde."ID" = cds_prod."MfID"
              )
            FROM cds_prod
          sql
        end
      end
    end
  end
end