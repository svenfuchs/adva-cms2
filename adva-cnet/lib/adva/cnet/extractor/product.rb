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
            INSERT INTO #{table_name} (
              product_number, 
              manufacturer_part_number,
              status, 
              cat_id, 
              mf_id, 
              mkt_id, 
              img_id, 
              created_at, 
              updated_at
            )
            SELECT * FROM dblink('cnet_origin', 
              'SELECT
                cds_prod."ProdID",
                cds_prod."MfPN",
                (
                  SELECT cds_catalog."StatusCode"
                  FROM cds_catalog
                  WHERE cds_catalog."ProdID" = cds_prod."ProdID"
                ),
                cds_prod."CatID", 
                cds_prod."MfID",
                cds_prod."MktID", 
                cds_prod."ImgID", 
                NOW(), NOW()
              FROM cds_prod'
            ) 
            AS t1(
              product_number varchar(255), 
              manufacturer_part_number varchar(255),
              status varchar(255), 
              cat_id varchar(255), 
              mf_id varchar(255), 
              mkt_id varchar(255),
              img_id varchar(255), 
              created_at timestamp, 
              updated_at timestamp
            )
          sql
        end
      end
    end
  end
end