module Adva
  class Cnet
    module Importer
      class Product
        delegate :execute, :select_values, :to => :connection
        attr_reader :connection, :table_name

        def initialize(connection, table_name)
          @connection = connection
          @table_name = table_name
        end
        
        def run
          # start_transaction
          create_tmp_table
          copy_data_to_tmp_table
          update_existing_records
          insert_new_records
          # commit_transaction
        end

        def tmp_table_name
          @tmp_table_name ||= "temp_#{table_name}_#{object_id}"
        end

        def create_tmp_table
          execute <<-sql
            CREATE TEMPORARY TABLE #{tmp_table_name} AS 
            SELECT * FROM production.#{table_name} WHERE 1 <> 1
          sql
        end
        
        def copy_data_to_tmp_table
          execute <<-sql
            INSERT INTO #{tmp_table_name} 
            SELECT * FROM import.#{table_name}
          sql
        end
        
        def update_existing_records
          fields  = %w(product_number mkt_id cat_id)
          updates = fields.map { |field| "#{field} = (SELECT #{field} FROM #{tmp_table_name} WHERE #{table_name}.product_number = #{table_name}.product_number)" }.join(', ')
          execute <<-sql
            UPDATE #{table_name}
            SET #{updates} 
            -- FROM #{tmp_table_name} 
            WHERE #{table_name}.product_number IN (SELECT product_number FROM #{tmp_table_name})
          sql
        end
        
        def insert_new_records
          fields  = %w(product_number mkt_id cat_id)
          
          execute <<-sql
            INSERT INTO #{table_name} (#{fields.join(', ')})
            SELECT #{fields.join(', ')}
            FROM #{tmp_table_name} 
            WHERE product_number NOT IN (SELECT product_number FROM #{table_name});
          sql
        end

        def insert_statement(table_name)
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
            ON DUPLICATE KEY UPDATE
              manufacturer_part_number = VALUES(manufacturer_part_number),
              status                   = VALUES(status),
              updated_at               = VALUES(updated_at),
              cat_id                   = VALUES(cat_id),
              mf_id                    = VALUES(mf_id),
              mkt_id                   = VALUES(mkt_id),
              img_id                   = VALUES(img_id);
          sql
        end
      end
    end
  end
end

# -- sk_product_id            = VALUES(sk_product_id),
# -- cnet_category_id         = VALUES(cnet_category_id),
# -- cnet_manufacturer_id     = VALUES(cnet_manufacturer_id),
# (
#   SELECT #{sk_product_table_name}.id
#   FROM #{sk_product_table_name}
#   WHERE #{sk_product_table_name}.product_number = origin.cds_prod.ProdID
# ),
# (
#   SELECT #{category_table_name}.id
#   FROM #{category_table_name}
#   WHERE #{category_table_name}.cat_id = origin.cds_prod.CatID
# ),
# (
#   SELECT #{manufacturer_table_name}.id
#   FROM #{manufacturer_table_name}
#   WHERE #{manufacturer_table_name}.mf_id = origin.cds_prod.MfID
# ),
