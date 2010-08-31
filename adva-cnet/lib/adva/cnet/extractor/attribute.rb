module Adva
  class Cnet
    module Extractor
      class Attribute < Base
        def column_names
          %w(ext_value_id section_name key_name display_value sort_order)
        end
        
        def origin_select_statements
          mspec = <<-sql
            SELECT
              ('mspec--' || mspec."HdrID" || '-' || mspec."ProdID" || '-' || mspec."BodyID") AS ext_key_id,
              NULL                 AS section_name,
              header."Text"        AS key_name,
              body."Text"          AS display_value,
              mspec."DisplayOrder" AS sort_order
            FROM cds_mspecde AS mspec
              LEFT JOIN cds_mvocde  AS header  ON header."ID" = mspec."HdrID"
              LEFT JOIN cds_mvocde  AS body    ON body."ID"   = mspec."BodyID"
          sql
          espec = <<-sql
            SELECT
              ('espec-' || espec."SectID" || '-' || espec."HdrID" || '-' || espec."ProdID" || '-' || espec."BodyID") AS ext_key_id,
              section."Text"       AS section_name,
              header."Text"        AS key_name,
              body."Text"          AS display_value,
              espec."DisplayOrder" AS sort_order
            FROM cds_especde AS espec
              LEFT JOIN cds_evocde  AS section ON section."ID" = espec."SectID"
              LEFT JOIN cds_evocde  AS header  ON header."ID"  = espec."HdrID"
              LEFT JOIN cds_evocde  AS body    ON body."ID"    = espec."BodyID"
          sql
          [mspec, espec]
        end
      end
    end
  end
end