module Adva
  class Cnet
    class Origin
      module Fixtures
        class Extraction
          LOCALES = %w(de)
          
          attr_reader :source, :target, :prod_ids

          def initialize(source, target, prod_ids)
            source   ||= Adva::Cnet.root.join('db/dump/origin.full.sqlite3')
            target   ||= Adva::Cnet.root.join('db/dump/origin.fixtures.sqlite3')
            prod_ids ||= %w(100329 100372 100724 100732 100733)

            @source = Database.new(source)
            @target = Database.new(target)
            @prod_ids = prod_ids
          end

          def run
            extract_prod
            LOCALES.each do |locale| 
              extract_mkt(locale)
              extract_stdn(locale)
              extract_mspec(locale)
              extract_espec(locale)
            end
          end

          def extract_prod
            table_name = 'cds_prod'
            rows = source.select_rows(["SELECT * FROM #{table_name} WHERE ProdID IN (?)", prod_ids])
            rows.each { |row| target.insert(table_name, row) }
          end
          
          def extract_mkt(locale)
            mkt_ids = target.select_values(["SELECT MktID FROM cds_prod WHERE ProdID IN (?)", prod_ids])
            table_name = "cds_mkt#{locale}"
            rows = source.select_rows(["SELECT * FROM #{table_name} WHERE MktID IN (?)", mkt_ids])
            rows.each { |row| target.insert(table_name, row) }
          end

          def extract_stdn(locale)
            table_name = "cds_stdn#{locale}"
            rows = source.select_rows(["SELECT * FROM #{table_name} WHERE ProdID IN (?)", prod_ids])
            rows.each { |row| target.insert(table_name, row) }
          end

          def extract_mspec(locale)
            table_name = "cds_mspec#{locale}"
            rows = source.select_rows(["SELECT * FROM #{table_name} WHERE ProdID IN (?)", prod_ids])
            rows.each { |row| target.insert(table_name, row) }
            extract_mvoc(locale)
          end
          
          def extract_mvoc(locale)
            table_name = "cds_mspec#{locale}"
            hdr_ids  = target.select_values(["SELECT HdrID  FROM #{table_name} WHERE ProdID IN (?)", self.prod_ids])
            body_ids = target.select_values(["SELECT BodyID FROM #{table_name} WHERE ProdID IN (?)", self.prod_ids])

            table_name = "cds_mvoc#{locale}"
            rows = source.select_rows(["SELECT * FROM #{table_name} WHERE ID  IN (?)", hdr_ids + body_ids])
            rows.each { |row| target.insert(table_name, row) }
          end

          def extract_espec(locale)
            table_name = "cds_espec#{locale}"
            rows = source.select_rows(["SELECT * FROM #{table_name} WHERE ProdID IN (?)", prod_ids])
            rows.each { |row| target.insert(table_name, row) }
            extract_evoc(locale)
          end
          
          def extract_evoc(locale)
            table_name = "cds_espec#{locale}"
            hdr_ids  = target.select_values(["SELECT HdrID  FROM #{table_name} WHERE ProdID IN (?)", self.prod_ids])
            sect_ids = target.select_values(["SELECT SectID FROM #{table_name} WHERE ProdID IN (?)", self.prod_ids])
            body_ids = target.select_values(["SELECT BodyID FROM #{table_name} WHERE ProdID IN (?)", self.prod_ids])

            table_name = "cds_evoc#{locale}"
            rows = source.select_rows(["SELECT * FROM #{table_name} WHERE ID  IN (?)", hdr_ids + sect_ids + body_ids])
            rows.each { |row| target.insert(table_name, row) }
          end
        end
      end
    end
  end
end