module Adva
  class Cnet
    class Connections
      class Origin < ActiveRecord::Base
        establish_connection('cnet_origin')
      end
    
      class Import < ActiveRecord::Base
        establish_connection('cnet_import')
      end
      
      class << self
        def origin
          Origin.connection
        end
      
        def import
          Import.connection
        end
      end
    end
  end
end