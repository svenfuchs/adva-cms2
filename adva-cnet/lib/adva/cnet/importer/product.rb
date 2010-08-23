# module Adva
#   class Cnet
#     module Import
#       class Product
#         attr_reader :connection, :table_name
#
#         def initialize(connection, table_name)
#           @connection = connection
#           @table_name = table_name
#         end
#
#         def temp_table_name
#           @temp_table_name ||= "temp_#{table_name}_#{object_id}"
#         end
#
#         def create_temporary_table
#           connection.execute <<-sql
#             CREATE TEMPORARY TABLE #{temp_table_name} AS
#               SELECT * FROM #{table_name} WHERE 1 <> 1;
#           sql
#           p connection.execute("SELECT name FROM sqlite_master  WHERE type = 'table' AND NOT name = 'sqlite_sequence'")
#         end
#
#         def update_or_insert
#           import_target = 'import.products'
#
#           fields = []
#
#           rows = []
#
#           field_updates = fields.map do |field|
#             "#{field} = temporary_table.#{field}"
#           end.join(', ')
#
#           <<-sql
# START TRANSACTION;
#   -- create a temporary table for the new data (without data)
#   CREATE TEMPORARY TABLE temporary_table AS
#     SELECT * FROM #{import_target} WHERE false;
#
#   -- copy new data into temporary table
#   #{insert_statement('temporary_table')}
#
#   -- lock table to prevent race conditions
#   LOCK TABLE #{import_target};
#
#   -- update table with newer data (found in both temporary and real table)
#   UPDATE #{import_target}
#     SET #{field_updates}
#       FROM temporary_table
#       WHERE #{import_target}.id=temporary_table.id;
#
#   -- insert anything really new
#   INSERT INTO #{import_target}
#     SELECT *
#     FROM temporary_table
#     WHERE id NOT IN (SELECT id FROM #{import_target}) AS a;
# COMMIT;
#           sql
#         end
#
#         def insert_statement(table_name)
#           <<-sql
#             INSERT INTO import.#{table_name} (product_number, manufacturer_part_number,
#               status, cat_id, mf_id, mkt_id, img_id, created_at, updated_at)
#               SELECT
#                 origin.cds_prod.ProdID,
#                 origin.cds_prod.MfPN,
#                 (
#                   SELECT origin.cds_catalog.StatusCode
#                   FROM origin.cds_catalog
#                   WHERE origin.cds_catalog.ProdID = origin.cds_prod.ProdID
#                   ORDER BY timestamp DESC
#                   LIMIT 1
#                 ),
#                 origin.cds_prod.CatID, origin.cds_prod.MfID,
#                 origin.cds_prod.MktID, origin.cds_prod.ImgID,
#                 '#{Time.now.to_s(:db)}', '#{Time.now.to_s(:db)}'
#               FROM origin.cds_prod
#             ON DUPLICATE KEY UPDATE
#               manufacturer_part_number = VALUES(manufacturer_part_number),
#               status                   = VALUES(status),
#               updated_at               = VALUES(updated_at),
#               cat_id                   = VALUES(cat_id),
#               mf_id                    = VALUES(mf_id),
#               mkt_id                   = VALUES(mkt_id),
#               img_id                   = VALUES(img_id);
#           sql
#         end
#       end
#     end
#   end
# end
#
# # -- sk_product_id            = VALUES(sk_product_id),
# # -- cnet_category_id         = VALUES(cnet_category_id),
# # -- cnet_manufacturer_id     = VALUES(cnet_manufacturer_id),
# # (
# #   SELECT #{sk_product_table_name}.id
# #   FROM #{sk_product_table_name}
# #   WHERE #{sk_product_table_name}.product_number = origin.cds_prod.ProdID
# # ),
# # (
# #   SELECT #{category_table_name}.id
# #   FROM #{category_table_name}
# #   WHERE #{category_table_name}.cat_id = origin.cds_prod.CatID
# # ),
# # (
# #   SELECT #{manufacturer_table_name}.id
# #   FROM #{manufacturer_table_name}
# #   WHERE #{manufacturer_table_name}.mf_id = origin.cds_prod.MfID
# # ),
