


  
  
    def stage_and_import(archive_filename)
      Sk::Logger.log_type = 'cnet.import'
      stage_update(archive_filename)    # populates the cnet staging database
      import_cnet_database              # touches product.updated_at
      queue_digital_content_downloads   # touches product.updated_at
      # queue_pdf_exports                 # exports based on product.updated_at
    end
    log_method_call :stage_and_import
  
    def stage_update(archive_filename)
      Sk::Logger.log_type = 'cnet.import'
      extract(archive_filename)
      stage_incremental_update
    end
    log_method_call :stage_update
  
    def import_cnet_database
      Sk::Logger.log_type = 'cnet.import'
      cnet_models.each do |model|
        ActiveRecord::Base.transaction do
          model.import_from_cnet
        end
      end
      synchronize_foreign_keys
    end
    log_method_call :import_cnet_database
  
    def queue_digital_content_downloads
      Sk::Logger.log_type = 'cnet.import'
      urls = Cnet::DataSource.connection.select_values("SELECT url FROM cds_digcontent")
      urls.each { |url| Cnet::DigitalContent.send_later(:fetch!, url) if url =~ /\.(png|gif|jpg|jpeg)$/ }
      Sk::Logger.new.info("Queued #{urls.size} digital contents for download.")
    end
    log_method_call :queue_digital_content_downloads
  
    def queue_pdf_exports
    end
  
    def extract(archive_filename)
      Sk::Logger.log_type = 'cnet.import'
      `rm -rf #{Cnet.tmp_dir}/*; unzip #{archive_filename} -d #{Cnet.tmp_dir}`
    end
    log_method_call :extract
  
    def stage_incremental_update
      Sk::Logger.log_type = 'cnet.import'
      Dir["#{tmp_dir}/**/*.txt"].each do |file|
        table_name = "cds_#{File.basename(file, '.txt')}"
        table_name = table_name.gsub('Digital_Content', 'digcontent').gsub('Language', 'lang')
        table_name = table_name.gsub('Catalog_Info', 'catalog') # huh? should be renamed and importers should be adjusted
        table_name.downcase!
  
        without_constraints_on(table_name, Cnet::DataSource.connection) do |conn|
          conn.execute("TRUNCATE #{table_name};")
          conn.execute(<<-sql
            LOAD DATA LOCAL INFILE '#{file}'
            INTO TABLE #{table_name}
            CHARACTER SET 'latin1'
            FIELDS TERMINATED BY '\t'
              ENCLOSED BY ''
              ESCAPED BY ''
            LINES TERMINATED BY '\r\n';
            sql
          )
  
          conn.execute("UPDATE #{table_name} SET LanguageCode = 'en' WHERE LanguageCode = 'Inv'") if table_name == 'cds_digcontent_lang_links'
        end
      end
    end
    log_method_call :stage_incremental_update
  
    def synchronize_foreign_keys
      [Cnet::Product, Cnet::ProductAttribute].each(&:synchronize_foreign_keys)
    end
    log_method_call :synchronize_foreign_keys
  
    def cnet_models
      [
        Cnet::Category,
        Cnet::Manufacturer,
        Cnet::Product,
        Cnet::ProductAttribute,
        Cnet::Specification,
        Cnet::DigitalContentMediaType,
        Cnet::DigitalContent,
        Cnet::DigitalContentAssignment,
        Cnet::DigitalContentAttribute
      ]
    end
  
  module ClassMethods
    def available_locales
      Cnet.available_locales
    end
  
    def locale_mappings
      Cnet.locale_mappings
    end
  
    def import_from_cnet(options = {})
      Cnet.without_constraints_on(table_name, connection) do |conn|
        statements = cnet_insert_statement(options).split("\0").reject(&:blank?)
        statements.each { |sql| conn.execute(sql) }
      end
      finish_import if respond_to?(:finish_import)
    end
  
    def quote(value)
      connection.quote(value)
    end
  end