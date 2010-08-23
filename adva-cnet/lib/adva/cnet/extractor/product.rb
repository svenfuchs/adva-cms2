module Adva
  class Cnet
    module Extractor
      class Product
        attr_reader :connection, :table_name

        def initialize(connection, table_name)
          @connection = connection
          @table_name = table_name
        end
        
        def run
          connection.execute(insert_statement)
        end

        def insert_statement
          <<-sql
            INSERT INTO import.#{table_name} (product_number, manufacturer_part_number,
              status, cat_id, mf_id, mkt_id, img_id, created_at, updated_at)
              SELECT
                origin.cds_prod.ProdID,
                origin.cds_prod.MfPN,
                (
                  SELECT origin.cds_catalog.StatusCode
                  FROM origin.cds_catalog
                  WHERE origin.cds_catalog.ProdID = origin.cds_prod.ProdID
                  ORDER BY timestamp DESC
                  LIMIT 1
                ),
                origin.cds_prod.CatID, origin.cds_prod.MfID,
                origin.cds_prod.MktID, origin.cds_prod.ImgID,
                '#{Time.now.to_s(:db)}', '#{Time.now.to_s(:db)}'
              FROM origin.cds_prod
          sql
        end
      end
    end
  end
end