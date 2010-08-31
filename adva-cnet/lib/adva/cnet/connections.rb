require Adva::Cnet.root.join('db/cnet/config.rb')

module Adva
  class Cnet
    module Connections
      postgres_config = POSTGRES_CONFIG.merge(
        :database           => 'postgres',
        :schema_search_path => 'public'
      )

      class Postgres < ActiveRecord::Base; end
      postgres  = Postgres.establish_connection(postgres_config).connection
      databases = postgres.select_values('SELECT datname FROM pg_database')

      %w(cnet_origin cnet_import cnet_tmp).each do |name|
        config = POSTGRES_CONFIG.merge(:database => name)
        ActiveRecord::Base.configurations[name] = config
        postgres.create_database(name, config) unless databases.include?(name)
      end
      
      class << self
        def origin
          @origin ||= Connection.new(Origin.connection)
        end
      
        def import
          @import ||= Connection.new(Import.connection, :with_link => 'cnet_origin')
        end
      
        def tmp
          @tmp ||= Connection.new(Tmp.connection)
        end
      end

      class Origin < ActiveRecord::Base
        establish_connection('cnet_origin')
      end
    
      class Import < ActiveRecord::Base
        establish_connection('cnet_import')
      end
    
      class Tmp < ActiveRecord::Base
        establish_connection('cnet_tmp')
      end
    end
  end
end